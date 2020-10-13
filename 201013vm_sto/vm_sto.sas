/*******************************************************************************
COMPUTES ORIGINAL STOCK RETURNS AND VOLATILITY-MANAGED STOCK RETURNS
*******************************************************************************/
option nonotes;

data all01;
	input id $ @@;
	address=compress("https://query1.finance.yahoo.com/v7/finance/download/"||
		id||"?period1="||dhms("1jan1901"d,0,0,0)-3653*24*60*60||'&period2='||
		dhms("31dec2100"d,23,59,59)-3653*24*60*60);
	infile dummy url filevar=address firstobs=2 dsd truncover end=last;
	do until(last);
		input date yymmdd10. +1 open high low close adjusted volume;
		if adjusted>. then output;
	end;
cards;
^irx ba cat cvx dis ge hpq ibm ko pg xom
;

option notes;

/*COMPUTE DAILY RETURNS AND MONTHLY VOLATILITIES*/
proc sql;
	create table rid as
		select i.id,i.date,i.adjusted as ri,j.adjusted as rf
		from all01(where=(id^="^irx")) i
			left join all01(where=(id="^irx")) j on i.date=j.date
		order by id,date;
quit;

data rid;
	set rid;
	rf=ifn(id=lag(id) & lag(rf)>.,lag(rf)/365,lag2(rf)/365);
	ri=ifn(id=lag(id),ri/lag(ri)*100-100-rf,.);
run;

proc sql;
	create table vit as
		select id,date,sqrt(css(ri)) as vi
		from rid
		group by id,put(date,yymm.)
		having date=max(date)
		order by id,date;
quit;

/*COMPUTE MONTHLY ORIGINAL RETURNS*/
proc sql undo_policy=none;
	create table rit as
		select id,date,adjusted
		from all01
		group by id,put(date,yymm.)
		having date=max(date)
		order by id,date;
	create table rit as
		select i.id,i.date,i.adjusted as ri,j.adjusted as rf
		from rit(where=(id^="^irx")) i left join rit(where=(id="^irx")) j
			on put(i.date,yymm.)=put(j.date,yymm.)
		order by id,date;
quit;

data rit;
	set rit;
	rf=ifn(id=lag(id),lag(rf)/12,.);
	ri=ifn(id=lag(id),ri/lag(ri)*100-100-rf,.);
run;

/*COMPUTE MONTHLY VOLATILITY-MANAGED RETURNS*/
proc sql;
	create table all02 as
		select i.id,i.date,ri,ri/vi/std(ri/vi)*std(ri) as mi,
			ri+rf as cri,calculated mi+rf as cmi
		from rit i join vit j
			on i.id=j.id and intnx("month",i.date,0)=intnx("month",j.date,1)
		order by id,date;
quit;

proc expand method=none out=all02;
	by id;
	id date;
	convert cri/tout=(/100 +1 cuprod);
	convert cmi/tout=(/100 +1 cuprod);
run;

%macro sgplot(id);

ods graphics/reset imagename="_&id." outputfmt=pdf width=4in height=1.5in noborder;

proc sgplot noautolegend;
	where id="&id.";
	series x=date y=cri/lineattrs=(color=red pattern=solid);
	series x=date y=cmi/lineattrs=(color=lime pattern=solid);
	xaxis label="year" valuesformat=year4.;
	yaxis label="&id." valuesformat=best8. type=log;
run;

%mend;

ods html close;
ods results=off;
ods listing gpath="!userprofile\desktop\201013vm_sto\";
option topmargin=0.001in bottommargin=0.001in leftmargin=0.001in
	rightmargin=0.001in;

%sgplot(ba)%sgplot(cat)%sgplot(cvx)%sgplot(dis)%sgplot(ge)
%sgplot(hpq)%sgplot(ibm)%sgplot(ko)%sgplot(pg)%sgplot(xom)

ods graphics/reset;
ods listing gpath=none;

data all02;
	set all02(in=i) all02(in=j);
	if i then id=" ";
run;

ods select none;

proc model;
	mi=alpha/12+beta*ri;
	fit mi/gmm vardef=n kernel=(bart,1,0);
	by id;
	ods output parameterestimates=alpha;
quit;

ods results=on;
ods select all;

proc sql undo_policy=none;
	create table alpha as
		select upcase(i.id) as ID,
			i.estimate as Alpha format=8.2,
			compress("("||put(i.tvalue,6.2)||")") as tAlpha,
			j.estimate as Beta format=8.2,
			compress("("||put(j.tvalue,6.2)||")") as tBeta
		from alpha(where=(parameter="alpha")) i
			join alpha(where=(parameter="beta")) j on i.id=j.id
		order by id;
quit;

data alpha;
	set alpha(firstobs=2) alpha(obs=1);
run;

proc export replace file="!userprofile\desktop\201013vm_sto\_alpha.csv";
run;
