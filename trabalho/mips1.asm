.data
    localArquivo: .asciiz "C:\\Users\\alunoi5\\Desktop\\arquitetura\\lista.txt"
    conteudoArquivo: .space 1024                            
    mensagem: .asciiz "Conte�do do arquivo:\n"              
    mensagemOrdenado: .asciiz "\nConte�do ordenado:\n"      
    numeros: .word 510,247,-107,858,465,777,-728,-15,165,717,323,968,636,906,-555,-300,-580,-264,189,-739,996,-867,400,-334,969,786,-655,-630,-461,255,-221,510,391,745,306,-444,661,-564,-804,-99,-885,444,28,763,-878,682,418,-558,-719,55,-78,977,-885,-666,-467,-151,-831,720,31,-796,-285,-573,211,517,-587,-519,-296,-499,974,85,-645,129,823,740,-667,286,-652,-856,-186,83,600,132,-117,-905,-683,81,-368,738,498,-257,54,796,142,-519,-348,-485,16,-989,-58,-770    # Array de n�meros a serem ordenados
    array: .space 400 
    tamanho: .word 100                     
    nova_linha: .asciiz "\n"              

.text
main:
    
    li $v0, 13                              
    la $a0, localArquivo                    
    li $a1, 0                               
    syscall                                 

    move $s0, $v0                           

    # Ler o conte�do do arquivo
    li $v0, 14                              #  ler do arquivo
    move $a0, $s0                           
    la $a1, conteudoArquivo                 # Endere�o conteudo
    li $a2, 1024                            
    syscall                                 

    # caractere nulo 
    move $t0, $v0                           
   la $t1, conteudoArquivo               
    add $t1, $t1, $t0                      
    sb $zero, 0($t1)                        # Insere o caractere nulo 

    #imprimir
    li $v0, 4                               # imprimir string
    la $a0, mensagem                        # Endere�o da mensagem
    syscall                             

    # Exibir o conte�do lido
    li $v0, 4                              
    la $a0, conteudoArquivo                
    syscall                                 # Chamar o sistema

    # Ordenar o array usando Bubble Sort
    jal boble_sort                          # Chama a fun��o para ordenar

    # Exibir a mensagem para o conte�do ordenado
    li $v0, 4                               
    la $a0, mensagemOrdenado               
    syscall                                

    # Imprime a lista ordenada
    la $t0, numeros                   # Ponteiro para o in�cio do array
    li $t1, 0                         # Contador de n�meros impressos

print_loop:
    lw $a0, 0($t0)                   # Carrega o pr�ximo n�mero em $a0
    li $v0, 1                         # syscall para printar integer
    syscall                           # Imprime o n�mero

    # Printa nova linha
    li $v0, 4                         # syscall para imprimir string
    la $a0, nova_linha                # Endere�o da nova linha
    syscall                           # Imprime nova linha

    addi $t0, $t0, 4                  # Avan�a para o pr�ximo n�mero
    addi $t1, $t1, 1                  # Incrementa o contador
    lw $t2, tamanho                   # Carrega o tamanho do array
    bne $t1, $t2, print_loop          # Continua imprimindo at� o final do array

encerrar:
    # Finaliza o programa
    li $v0, 10                        # syscall para finalizar
    syscall

.globl boble_sort
boble_sort:
    # Inicializa ponteiros e contadores
    la $t0, numeros                   
    lw $t1, tamanho                   

    # Loop externo para o Bubble Sort
outer_loop:
    li $t2, 0                         # Inicializa contador 
    li $t3, 0                         

inner_loop:
    # Compara dois elementos adjacentes
    lw $t4, 0($t0)                   # Carrega o elemento atual
    lw $t5, 4($t0)                   # Carrega o pr�ximo elemento

    # Verifica se o elemento atual � maior que o pr�ximo
    ble $t4, $t5, no_swap            # Se n�o for maior, n�o faz a troca

    # Troca os elementos
    sw $t5, 0($t0)                  
    sw $t4, 4($t0)                  
    li $t3, 1                        

no_swap:
    addi $t0, $t0, 4                 
    addi $t2, $t2, 1                  
    lw $t6, tamanho                 
    sub $t6, $t6, 1                   
    bne $t2, $t6, inner_loop          

    # Se n�o houve trocas, o array est� ordenado
    beqz $t3, done                    # Se n�o houve trocas, termina

    # Reseta o ponteiro para o in�cio do array e continua o loop externo
    la $t0, numeros                   # Reseta o ponteiro
    j outer_loop

done:
    jr $ra                             # Retorna ao chamador ap�s ordenar

