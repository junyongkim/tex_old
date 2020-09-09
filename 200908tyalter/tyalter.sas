filename a "%sysfunc(getoption(work))\a";

proc http url="https://raw.githubusercontent.com/junyongkim/sas_old/master/191211bbgbdata/191226BBGBdata.xls" out=a;
run;

proc import file=a dbms=xls replace out=ty;
	sheet="monthly";
run;

%macro fred(id);

data &id.;
	infile "https://fred.stlouisfed.org/graph/fredgraph.csv?id=&id." url firstobs=2 dsd truncover;
	input date yymmdd10. +1 &id.;
	month=intnx("month",date,0);
run;

proc sort;
	by month descending date;
run;

proc sort data=&id.(where=(&id.>.)) nodupkey out=&id.(drop=month);
	by month;
run;

%mend;

%fred(t10yff)
%fred(t10y2y)
%fred(t10y3m)
%fred(gs10)
%fred(gs5)
%fred(gs3)
%fred(gs2)
%fred(gs1)
%fred(dgs3mo)

proc sql;
	create table all as
		select intnx("month",input(put(a.date,6.),yymmn6.),0,"end") as date,a.ty+0 as ty,
			t10yff,
			t10y2y,
			t10y3m,
			gs10-gs5 as gs10gs5,
			gs10-gs3 as gs10gs3,
			gs10-gs2 as gs10gs2,
			gs10-gs1 as gs10gs1,
			gs10-mean(gs3,gs1) as gs10gsm,
			gs10-dgs3mo as gs10dgs3mo
		from ty a
			left join t10yff b on put(a.date,6.)=put(b.date,yymmn6.)
			left join t10y2y c on put(a.date,6.)=put(c.date,yymmn6.)
			left join t10y3m d on put(a.date,6.)=put(d.date,yymmn6.)
			left join gs10 e on put(a.date,6.)=put(e.date,yymmn6.)
			left join gs5 f on put(a.date,6.)=put(f.date,yymmn6.)
			left join gs3 g on put(a.date,6.)=put(g.date,yymmn6.)
			left join gs2 h on put(a.date,6.)=put(h.date,yymmn6.)
			left join gs1 i on put(a.date,6.)=put(i.date,yymmn6.)
			left join dgs3mo j on put(a.date,6.)=put(j.date,yymmn6.)
		order by date;
quit;

data _null_;
	infile "%sysfunc(getoption(work))\all.sas7bdat" recfm=f;
	input;
	file "!userprofile\desktop\200908tyalter\tyalter.sas7bdat" recfm=n;
	put _infile_;
run;

proc transpose out=transpose data=all;
	by date;
run;

proc sql;
	create table transpose as
		select a.*
		from transpose a
			join dictionary.columns b on _name_=name
			where libname="WORK" and memname="ALL"
		order by varnum,date;
quit;

ods select none;
ods results=off;

proc means maxdec=2 stackodsoutput n mean std skew kurt min q1 median q3 max;
	by notsorted _name_;
	var col1;
	ods output summary=means(drop=variable rename=(_name_=Variable));
run;

ods results=on;
ods select all;

proc iml;
	use all(drop=date);
	read all var _all_ into all;
	rmse=sqrt(((all-all[,1])##2)[:,]`);
	mattrib rmse format=12.2;
	create rmse from rmse[colname="RMSEty"];
	append from rmse;
quit;

data means;
	merge means rmse;
run;

proc export replace file="!userprofile\desktop\200908tyalter\means.csv";
run;

proc iml;
	use all(drop=date);
	read all var _all_ into all[colname=name];
	corr=corr(all,,"pairwise");
	mattrib corr format=10.2;
	create corr from corr[rowname=name colname=name];
	append from corr[rowname=name];
quit;

proc export replace file="!userprofile\desktop\200908tyalter\corr.csv";
run;

%macro sgplot(imagename);

ods results=off;
ods listing gpath="!userprofile\desktop\200908tyalter\series\";
ods graphics/reset imagename="&imagename." imagefmt=pdf width=6.5in height=1.75in noborder;
option topmargin=0.000001in bottommargin=0.000001in leftmargin=0.000001in rightmargin=0.000001in;

proc sgplot data=all noborder noautolegend;
	series y=&imagename. x=date/lineattrs=(pattern=solid color=blue);
	series y=ty x=date/lineattrs=(pattern=solid color=red);
	yaxis label="&imagename." valuesformat=best4.;
	xaxis label="year" valuesformat=year4.;
run;

ods listing gpath="!userprofile\desktop\200908tyalter\scatter\";
ods graphics/reset=index width=3.25in height=2.95in;

proc sgplot data=all noborder noautolegend;
	scatter y=ty x=&imagename./markerattrs=(symbol=circle color=blue);
	lineparm y=0 x=0 slope=1/lineattrs=(pattern=solid color=red);
	yaxis label="ty" valuesformat=best4.;
	xaxis label="&imagename." valuesformat=best4.;
run;

ods graphics/reset;
ods listing gpath=none;
ods results=on;

%mend;

%sgplot(t10yff)
%sgplot(t10y2y)
%sgplot(t10y3m)
%sgplot(gs10gs5)
%sgplot(gs10gs3)
%sgplot(gs10gs2)
%sgplot(gs10gs1)
%sgplot(gs10gsm)
%sgplot(gs10dgs3mo)
