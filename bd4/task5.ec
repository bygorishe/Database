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

   printf("\n\nЗадание N5\n");
   printf("Выдать полную информацию об изделиях, для которых поставлялись\n ТОЛЬКО детали из последнего по алфавиту города.\n");
   printf("\nTask N5\n");
   printf("Provide full information about products for which ONLY parts\n were supplied from the last city in alphabetical order.\n\n");

   exec sql begin declare section;
   char n_izd[7], name[21], town[21];
   exec sql end declare section;

   exec sql declare my_cursor cursor for select j.*
					from spj
					join j on j.n_izd = spj. n_izd
					where spj.n_det in (select n_det
								from p
								where town = (select town
										from p
										order by town desc
										limit 1))
					except
					select j.*
					from spj
					join j on j.n_izd = spj. n_izd
					where not spj.n_det in (select n_det
					from p
					where town = (select town
							from p
							order by town desc
							limit 1));

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
exec sql rollback;
      exec sql disconnect;
      exit(1); 

   }

   int rows = 0;
   exec sql fetch from my_cursor into :n_izd, :name, :town;
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
      printf("%s\t%s\t%s\n", n_izd, name, town);
      rows++;
 exec sql fetch from my_cursor into :n_izd, :name, :town;
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