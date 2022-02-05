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
      
   printf("\nЗадание №1 \n");
   printf("Выдать число цветов деталей, поставлявшихся поставщиками, выполнявшими поставки для изделий из Парижа.\n");
   printf("\nTask №1 \n");
   printf("Give out the number of colors for parts supplied by suppliers who supplied products from Paris.\n\n");

   exec sql begin declare section;
      int count;
   exec sql end declare section;    

   exec sql begin;

   exec sql 
   select count( distinct p.cvet) into:count
   from spj
   join p on p.n_det = spj.n_det
   where spj.n_post in(select spj.n_post
	  			     from spj
				     where spj.n_izd in(select distinct j.n_izd
							      from j
							      where j.town = 'Париж'));

   if (sqlca.sqlcode < 0) {
      printf("Error: in request \n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql rollback work;
   }

   printf("Count: %d\n\n", count);
   printf("Number of rows processed or returned = %d\n\n", sqlca.sqlerrd[2]);
   
   exec sql commit;
   printf("Sucсess\n");

   exec sql disconnect;
   return 0;
}