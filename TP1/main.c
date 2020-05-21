#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "merges/MergeSort.c"

void print_version(){
  printf("Version v0.000000\n");
}

void print_help(){

    printf(" Usage:\n");
    printf("\ttp1 -h\n");
    printf("\ttp1 -V\n");
    printf("\ttp1 -i in_file -o out_file\n");
    printf(" Options:\n");
    printf("\t-V, --version      Print version and quit.\n");
    printf("\t-h, --help         Print this information and quit.\n");
    printf("\t-i, --input        Specify input stream/file, \"-\" for stdin.\n");
    printf("\t-o, --output       Specify output stream/file, \"-\" for stdout.\n");
    printf(" Examples:\n");
    printf("\ttp1 < in.txt > out.txt\n");
    printf("\tcat in.txt | tp1 -i - > out.txt\n");
}


void print_command_error(){
    printf("Comando o secuencia de comandos invalidos.\n");
    printf("Escribe -h o --help para obtener ayuda.\n");
}


bool load_file(char* name, FILE** file, char* mode){
    
    FILE* temp_file = fopen(name,mode);
    if(!temp_file){
      printf("Couldn't open file\n");
      return false;
    }

    *file = temp_file;
    return true;
}


int do_number(int* cifras, int n){
    int number = 0;
    int digitos = 0;
    for(int i= 0; i < n ; i++ ){
      if(cifras[i] < 0 || 9 < cifras[i])break;
      digitos++;
    }
    for(int i = 0; i < digitos; i++){
        number += cifras[i];
        number *= 10;
    }
    return number/10;
}   


void print_number_list(FILE* file,int* vector, int n){
    for(int i = 0; i < n; i++){
        fprintf(file, "%d ",vector[i]);
    }
    fprintf(file,"\n");
}


int main(int argc, char* argv[]) {
    FILE* filein = NULL;
    FILE* fileout = NULL;

    bool success = true;
    for(int i = 1; i < argc; i++){

        if( !strcmp(argv[i],"-V") || !strcmp(argv[i],"--version")){
          print_version();
          return 0;

        }else if( !strcmp(argv[i],"-h") || !strcmp(argv[i],"--help")){
          print_help();
          return 0;

        }else if(!strcmp(argv[i],"-i") || !strcmp(argv[i],"--input")){

            //Si falta el nombre o no se cargo el archivo
            if(i+1 == argc || !load_file(argv[i+1],&filein,"r")){
                success = false;
                break;
            }
            i++; //ignorar el nombre del archivo

        }else if(!strcmp(argv[i],"-o") || !strcmp(argv[i],"--output")){
            //Si falta el nombre o no se cargo el archivo
            if(i+1 == argc || !load_file(argv[i+1],&fileout,"w")){
              success = false;
              break;
            }
            i++; //ignorar el nombre del archivo

        }else{

            //si no se reconoce el comando
            success = false;
            break;
        }

    }

    if(!success){
      print_command_error();
      return 0;
    }

    if(!filein) filein = stdin;
    if(!fileout) fileout = stdout;

    /*****************************/

	char** linea = NULL;
	size_t* largo = 0;
	size_t caracteres_leidos = getline(linea,largo,filein);
	size_t largo_maximo = caracteres_leidos;
	while(caracteres_leidos!= -1){
		caracteres_leidos = getline(linea,largo,filein);
		if(largo_maximo< caracteres_leidos){
			largo_maximo = caracteres_leidos;
		}
	}
	rewind(filein);
    int numeros_desordenados[largo_maximo];

    // ..de maximo 50 digitos ( numero_leido < 10^50 ). 
    //Parametros del numero que se esta leyendo:
    int vec_digitos[50];              
    int cant_digitos = 0;             

    // i = cantidad de numeros por linea = indice para guardar el prox numero.
    int i = 0;

    //Codigo ASCII del caracter leido
    int c = fgetc(filein);
  	while(c != EOF){

        //Si el caracter es un espacio o un "\n" 
        if(c == 32 || c == 10 ){

        	if( cant_digitos != 0 ) {

                //De haberse leido algun numero se guarda e incrementa el contador
				numeros_desordenados[i] = do_number(vec_digitos, cant_digitos);
				i++;
			}

            if( c == 10 ){

                //si se trata de un "\n" se ordenan los numeros y se imprime el resultado.
                int* numeros_ordenados = merge_sort(numeros_desordenados,i);
                print_number_list(fileout,numeros_ordenados,i);
                if(numeros_ordenados) free(numeros_ordenados);
                i=0;
            }
            cant_digitos=0;
            
        }else{

            //Se guardara cualquier otro caracter hasta ser procesado por do_number()
            c-= 48;
            vec_digitos[cant_digitos] = c;
            cant_digitos++;
        }

        c = fgetc(filein);
  	}

    if(filein != stdin) fclose(filein); 
    if(fileout != stdout) fclose(fileout);
    
    return 0;
  	//llamar funcion ordenadora con el vector de char*
  	//Habria que escribirla primero en C
}
