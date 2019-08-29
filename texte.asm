;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; PROJET   :  DE L'ASSEMBLEUR                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; THEME    :  CHIFFREMENT DE CESAR              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ETUDIANT :  MAAZAZ ZAKARIA & KABBORI ZAKARIA  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CLASSE   :  GLSID 1                           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                          
.model small   
.stack 100h     


.data          

RE      EQU  0DH
LI      EQU  0AH
car     db   "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@$"
weclome db   RE, LI,">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> BONJOUR <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<$" 
msg     db   'Programme de <<<<<<<****** Chiffrement de Cesar ******>>>>>> $'
msg1    db   RE, LI, ' ------> Tapez (1) pour chiffrer un message ', RE, LI, ' ------> Tapez (2) pour dechiffrer un message ', RE, LI, ' ------> Tapez (3) pour sortir ', RE, LI, '$'
msg2    db   RE, LI, 'Choix invalide, veuillez choisir une choix correcte! ', '$'
msg3    db   RE, LI, '--> Entrer votre message : ', '$'
msg4    db   RE, LI, '--> Le message chiffre est : ', '$'
msg5    db   RE, LI, '--> Entrer le message pour dechiffrer : ', '$'
msg6    db   RE, LI, '--> Le message dechiffrer est : ', '$'
msg7    db   RE, LI, '--> Entrer la cle : ', '$'    
msg8    db   RE, LI,'Votre choix: $'  
msg9    db   RE, LI,'Voulez vous retourner au menu principale:','$'
crlf    db   RE, LI,RE, LI,'$'   ;;; sauter deux lignes 
crlf2   db   RE, LI,'$'   ;;; sauter une seule ligne
buffer  db   50 dup('$')
tab     db   50 dup('$')
init    dw   0          ;; pour construire un entier a partir de le saisir au clavier

.code 

;;; procedure utilise par cle prive
;;; utiliser pour transformer une chaine de carectere des chiffres sous forme d'un nombre

entier proc
                     
lea bx,tab
ch1:
mov ah,01
int 21h
mov [bx],al
inc bx
cmp al,0dh
je ch2       ;;; quitter la premiere fois si l'utilisateur entre un seul chiffre                
mov ah,0  ;;;;;; il se peut que la cle depasse (9) ( comporte plus de deux chiffres >
mov cx,ax
mov ch,0
sub cl,'0'  ;;;; obtenir tranformer la cle entrer sous forme caracter a une chiffre
mov ax,init
mov init,0
mov dx,10
mul dx
add ax,cx
mov init,ax
jmp ch1
ch2:
ret    

entier endp

main proc   
    
     
    mov ax, @data
    mov ds, ax 

    ;;;;;;; pour retourne a deux lignes
    lea dx,crlf  
    mov ah,09h
    int 21h    

    ;;;;;;; afficher les carceteres de decor
    lea dx,car  
    mov ah,09h
    int 21h 

    ;;;;;;; pour retourne a la ligne
    lea dx,crlf  
    mov ah,09h
    int 21h  
           
    ;;;;;;; afficher le message de bienvenue
    mov ah,09h
    mov dx,offset weclome
    int 21h
     
    return: 
     
    ;;;;;;; pour retourne a la ligne
    lea dx,crlf  
    mov ah,09h
    int 21h
     
    
    ;;;;;;; message de chiffrement de cesar
	lea dx,msg
	mov ah,09		
	int 21h

	mov bx, offset buffer
       
    ;;;;;;; pour retourne a la ligne
    lea dx,crlf  
    mov ah,09h
    int 21h  
    
menu:
	lea dx,msg1
	mov ah,09		
	int 21h
            
    ;;;;;;; afficher le message choisir la choix
    mov ah,09h
    mov dx,offset msg8
    int 21h       
            
	mov ah,1	
	int 21h

	cmp al,'1'		; si choisir le chiffrement
	je choix1
	
	cmp al,'2'		; si choisir le dechiffrement
	je choix2

	cmp al,'3'		; si choisir de quitter le programme
	je fin

	cmp al,'3'		; si taper n'importe qui
	jne go  

go:   

    ;;;;;;; pour retourne a la ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h  
    
	lea dx, msg2
	mov ah, 09		; afficher le message invalide
	int 21h    
	
	;;;;;;; pour retourne a la ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h 

	jmp menu


choix1: ;;;;;; le choix de chiffrement

    ;;;;;;; pour retourne a la ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h
    
	lea dx,msg3	; afficher le message "entrez votre message"	
	mov ah,09
	int 21h
	
x1:   
	mov ah,1		; entrer les caracteres de la chaine
	int 21h 
     
	mov [bx],al		; Stocker la chaine de caracteres  (caractere par caractere>

	cmp al,RE
	je cle

	inc bx

	cmp al,RE
	jne x1

cle:
	lea dx,msg7
	mov ah,09		; entrer la cle
	int 21h   

	mov ax,0	; lire la cle
	call entier     ; l'appel de procedure 
	mov cx,init       ; stocker la cle sur cx

	mov bx,offset buffer  
	
	;;;;;;; pour retourne a la ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h  
    
    ;;;;;;; affiche de message chiffrer
    lea dx,msg4  
    mov ah,09h
    int 21h
                   
                  
x2:       
    
	cmp byte ptr [bx],RE		; jusqu'a la fin de chaine
	je fin ;;x10

	cmp byte ptr [bx]," "		; s'il s'agit d'une espace = 20h in ascii
	je x3
	
	add [bx], cx		; ajouter la cle a le caractere
	
	cmp byte ptr [bx],122		; si [bx] ne depasse pas la derniere lettre alphabetique z ( ASCII(z)=122 >
	jle x3

	cmp byte ptr [bx],122		; Sinon, [bx] - 26
	jg x4
   
    ;;;;; Pour afficher les caracteres   
x3:    
	mov ah, 2
	mov dl, [bx]		; l'interruption afficher l'espace ;
	                    ; NT 21h, function single character output to monitor
	                    ; input:    AH: 2
                        ; DL: character to display (ASCII value)
                        ; output:  none 
	int 21h
	
	inc bx
	jmp x2 
	
    ;;;;; si le caractere depasse asccii de "z"
x4:
	sub byte ptr [bx],26
	jmp x3


choix2:     

    ;;;;;;; pour retourne a la ligne
    lea  dx,crlf2  
    mov  ah,09h
    int  21h
    
	lea dx,msg5		; message de decrypter le message
	mov ah, 09
	int 21h

x5:
	mov ah,1		 
	int 21h

	mov [bx],al		; stocker la chaine crypter 

	cmp al,RE   ; la fin de chaine
	je x6

	inc bx

	cmp al,RE		 ; sinon continue
	jne x5

x6:
	lea dx,msg7
	mov ah,09		; afficher le message d'entrer la cle prive
	int 21h

	mov ax,0	
	call entier ;  l'appel de procedure qui permet transformer le caractere de chiffre se forme de nombre
	mov cx,init ; la cle prive

	mov bx,offset buffer 
	
	;;;;;;; pour retourne a la ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h
    
    ;;;;;;; pour afficher le message de dechiffrement
    lea dx,msg6  
    mov ah,09h
    int 21h

x7:
	cmp byte ptr [bx],RE		; c'est la chaine est fini
	je fin ;;x10

	cmp byte ptr [bx]," "		; si il y a une espace
	je x8
	
	sub [bx],cx		; ajouter la cle 
	
	cmp byte ptr [bx],96		;     si il est superieur a l'asccii 'a'
	jg x8

	cmp byte ptr [bx],96		; sinon : [bx] - 26
	jle x9

x8: 
	mov ah,2
	mov dl,[bx]		; afficher le message dechiffrer
	int 21h
	
	inc bx
	jmp x7

x9:
	add byte ptr [bx],26
	jmp x8 
	
	
x10:
     
    ;;;;;;; pour retourne a deux lignes
    lea dx,crlf  
    mov ah,09h
    int 21h    
  

    lea dx,msg9
    mov ah,09		; afficher le message de continue le programme
	int 21h       
       
    mov ah,1
    int 21h 
    mov cl,al
    
    ;;;;;;; pour retourne a deux lignes
    lea dx,crlf  
    mov ah,09h
    int 21h    

    ;;;;;;; afficher les carceteres de decor
    lea dx,car  
    mov ah,09h
    int 21h 
    
    ;;;;;;; pour retourne a un ligne
    lea dx,crlf2  
    mov ah,09h
    int 21h   
    
    cmp cl,'o'
    je return	
	  

fin:  
    
    ;;;;;;;; pour retourne a la ligne
    lea dx,crlf  
    mov ah,09h
    int 21h
                 
    ;;;;;;; pour retourne a deux lignes
    lea dx,crlf  
    mov ah,09h
    int 21h
                                  
    ;;;;;;;; pour afficher les caracteres de decor
    lea dx,car  
    mov ah,09h
    int 21h 
    
    ;;;;;;;; These two lines actually request the operating system to terminate the program          
                   
	mov ax, 4c00h
	int 21h
	
main endp
	end main     
	;; FIN                                       