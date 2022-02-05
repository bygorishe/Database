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

   printf("\n\nЗадание N3\n");
   printf("Найти изделия, имеющие поставки, объем которых более чем в 2 раза\n превышает средний объем поставки для изделия. Вывести номеризделия,\n объем поставки, средний объем поставки для изделия.\n");
   printf("\nTask N3\n");
   printf("Find wares that have shipments that are more than 2 times the average\n shipment for the product. Display the wares number, delivery quantity,\naverage delivery quantity for the item.\n\n");

   exec sql begin declare section;
   char n_izd[7];
   int kol, avg;
   exec sql end declare section;

   exec sql declare my_cursor cursor for select spj.n_izd, spj.kol, floor(t.avg) avg
       					 from spj
       					 join (select spj.n_izd, avg(spj.kol) avg
           					   from spj
	     					   group by spj.n_izd) t
					 on t.n_izd = spj.n_izd
       					 where spj.kol > 2*t.avg
       					 order by 1;

if (sqlca.sqlcode < 0)
   {
      printf("Declare finished with error.\n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql disconnect;
   }

   exec sql begin;

   exec sql open my_cursor;
   if (sqlca.sqlcode < 0)
   {
      printf("Unsuccessfully opening cursor. \n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql rollback work;
      exec sql disconnect;
      exit(1);
   }

   int rows = 0;
   exec sql fetch from my_cursor into :n_izd, :kol, :avg;

if(sqlca.sqlcode ==  ECPG_NOT_FOUND){
         printf("no data\n");
         exec sql close my_cursor;
         exec sql commit;
   }
else {
 printf("n_izd\tkol\tavg\n");
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
      printf("%s\t%d\t%d\n", n_izd, kol, avg);
      rows++;
      exec sql fetch from my_cursor into :n_izd, :kol, :avg;
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