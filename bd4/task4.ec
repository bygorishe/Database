#include <stdlib.h>

#define SERVER "students@fpm2.ami.nstu.ru"
#define login "pmi-b8112"
#define password "eefItUd8"
#define scheme_name "pmib8112"

void errorHandle(const char* error_name) {
   if (sqlca.sqlcode != ECPG_NO_ERROR && sqlca.sqlcode != ECPG_NOT_FOUND) {
      fprintf(stderr, "Error: %s\n", error_name);
      fprintf(stderr, "Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);

      exec sql rollback work;
      exit(EXIT_FAILURE);
   }
}

void connectToDatabase() {
   EXEC SQL CONNECT TO students@fpm2.ami.nstu.ru USER "pmi-b8112" USING "eefItUd8";
   errorHandle("database connection");
}

void connectToScheme() {
   EXEC SQL SET search_path TO pmib8112;
   errorHandle("scheme connection");
}

int main() {
   connectToDatabase();
   connectToScheme();

   printf("\n\nЗадание N4\n");
   printf("Выбрать изделия, для которых не поставлялась ни одна деталь, имеющая наибольший вес.\n");
   printf("\nTask N4\n");
   printf("Select wares for which no part with the greatest weight was supplied.\n\n");

   exec sql begin declare section;
   char n_izd[7];
   exec sql end declare section;

   exec sql declare my_cursor cursor for select distinct n_izd
					from spj
					except
					select distinct n_izd
					from spj
					where n_det = (select n_det
							from p
							where ves = (select max(ves)
									from p))
					order by 1;

if (sqlca.sqlcode < 0)
   {
      printf("Declare finished with error.\n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql disconnect;
      exit(1);
   }


 exec sql begin;

   exec sql open my_cursor;
   if (sqlca.sqlcode < 0)
   {
      printf("Unsuccessfully opening cursor. \n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql disconnect;
      exit(1); 
   }

   int rows = 0;
   exec sql fetch from my_cursor into :n_izd;

if(sqlca.sqlcode ==  ECPG_NOT_FOUND){
         printf("no data\n");
         exec sql close my_cursor;
         exec sql commit;
   }
else {
   while (sqlca.sqlcode == 0) 
   { 
if( sqlca.sqlcode < 0)
{
printf("Fetch finished with error. \n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
         exec sql close my_cursor;
      exec sql rollback work;

}
else if(sqlca.sqlcode == 0)
{
      printf("%s\n", n_izd);
      rows++;
   exec sql fetch from my_cursor into :n_izd;
}
}
}

   exec sql close my_cursor;

   printf("Number of rows processed or returned = %d\n\n", rows);
   
   exec sql commit;
   printf("Sucсess\n");

   exec sql disconnect;
   return 0;
}