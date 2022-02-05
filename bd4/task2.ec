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

   printf("\n\nЗадание N2\n");
   printf("Поменять местами названия деталей, стоящих первой и последней в списке, упорядоченном по весу и названию.\n");
   printf("\nTask N2\n");
   printf("Swap the names of the first and last parts in the list, sorted by weight and name.\n\n");

   exec sql begin;

   exec sql update p set name= (case when p.name =(select p5.name
                                                    from p p5
                                                    order by p5.ves , p5.name
                                                    limit 1)
                                    then ( select p3.name
                                            from p p3
                                            order by p3.ves desc, p3.name desc
                                            limit 1)
                                    else ( select p4.name
                                            from p p4
                                            order by p4.ves , p4.name
                                            limit 1)
                                    end)
                        where p.name=( select p1.name
                                        from p p1
                                        order by p1.ves, p1.name
                                        limit 1)
                            or p.name=( select p2.name
                                        from p p2
                                        order by p2.ves desc, p2.name desc
                                        limit 1);
   
   if (sqlca.sqlcode < 0) {
      printf("Error: in request \n");
      printf("Code %d: %s\n", sqlca.sqlcode, sqlca.sqlerrm.sqlerrmc);
      exec sql rollback;
   }

   printf("Number of rows processed or returned = %d\n\n", sqlca.sqlerrd[2]);
   
   exec sql commit;
   printf("Sucсess\n");

   exec sql disconnect;
   return 0;
}