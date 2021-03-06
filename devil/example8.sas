proc template;
   define style styles.journal_borders;
       parent = styles.journal;

       style header from header/
           font_weight = bold
           foreground = cx006666 
       ;

       
       style header_right from header /
             borderrightstyle=solid
             borderrightcolor=cx006666
             borderrightwidth=2
       ;

       style header_bottom_right from header_right /
             borderbottomstyle=solid
             borderbottomcolor=cx006666
             borderbottomwidth=2
       ;

       style header_thinbottom_right from header_right /
             borderbottomstyle=solid
             borderbottomcolor=cx006666
             borderbottomwidth=1
       ;
       style header_bottom from header /
             borderbottomstyle=solid
             borderbottomcolor=cx006666
             borderbottomwidth=2
       ;

       style data_bottom from data /
             borderbottomstyle=solid
             borderbottomcolor=black
             borderbottomwidth=1
       ;
       style data_bottom_right from data_bottom /
             borderrightstyle=solid
             borderrightcolor=cx006666
             borderrightwidth=2
       ;
    end;
run;

%let data_bottom = borderbottomstyle=solid borderbottomcolor=black borderbottomwidth=1;

%let data_bottom_right = &data_bottom borderrightstyle=solid borderrightcolor=cx006666 borderrightwidth=2;

%let header = foreground = cx006666 font_style = italic;

%let header_thin_bottom_right = &header
                                borderrightstyle=solid borderrightcolor=cx006666 borderrightwidth=2 
                                borderbottomstyle=solid borderbottomcolor=cx006666 borderbottomwidth=1 ;


data prof;
 input grade rpass year count percent;
cards;
1 2 2002 23 .099
1 2 2003 43 .082
1 2 2001 24 .021
2 3 2002 32 .089
2 3 2001 32 .079
2 3 2003 32 .069
3 4 2002 32 .089
3 4 2001 32 .079
3 4 2003 32 .069
4 2 2002 23 .099
4 2 2003 43 .082
4 2 2001 24 .021
;

ods tagsets.ExcelXP file='example8.xls' style=journal_borders options(sheet_name="Grade Passrate" zoom="200");

ods html file = "test.html";

proc report data = prof nowd;
     column grade grade=grade2 rpass year,(count percent);
     define grade / group order=data descending 'Grade'
                    style(column)=header
                    style(header) = header_bottom;
     define grade2 / noprint;
     define rpass / group ' ' order=internal 
                    style(header) = header_bottom_right;
     define year / across order=data descending ' ' 
                    style(header)=header_right;
     define count / '#'   style(header) = header_bottom;
     define percent / '%' format=percent. style(header) = header_bottom_right ;

    compute grade2;
        if mod(grade2, 2) = 0 then do;
            call define (_row_, "style/merge", "style = [background = CXCCFFFF]");
        end;

/*
        else if mod(grade2, 2) = 1 then do;
            call define (_row_, "style/merge", "style = [background = CX37E139]");
        end;
*/
    endcomp;

    compute grade;
        call define(_col_, "style/merge", "style=[&header]");
    endcomp;
        

    compute rpass;
        call define(_col_, "style/merge", "style=[&header_thin_bottom_right]");
    endcomp;

    compute percent;
        call define(_col_, "style/merge", "style=[&data_bottom_right tagattr='format: 0.0%']");
    endcomp;

run;

ods tagsets.ExcelXP close;

