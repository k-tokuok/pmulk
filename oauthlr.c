/*
	OAuth loopback redirection receiver.
	$Id: mulk oauthlr.c 868 2022-05-17 Tue 21:13:37 kt $
*/

#include "std.h"

#if UNIX_P
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

#define SOCKET int
#define SOCKET_ERROR (-1)
#define INVALID_SOCKET (-1)
#endif

#if WINDOWS_P
#include <winsock2.h>

typedef int socklen_t;
#endif

#define BUFSIZE 1024

static void print_recv(SOCKET sock)
{
	char buf[BUFSIZE];
	int len;
	len=recv(sock,buf,BUFSIZE,0);
	if(len==SOCKET_ERROR) xerror("recv failed");
	if(len==BUFSIZE) xerror("too long recv");
	buf[len]='\0';
	printf("%s\n",buf);
}

static void close_socket(SOCKET sock)
{
#if UNIX_P
	close(sock);
#endif

#if WINDOWS_P
	closesocket(sock);
#endif
}

int main(int argc,char *argv[])
{
	SOCKET sock,csock;
	int port,len,true;
	struct sockaddr_in addr,caddr;
	
	char send_data[]=
		"HTTP/1.0 200 OK\r\n"
		"Content-Length: 2\r\n"
		"Content-Type: text/html\r\n"
		"\r\n"
		"ok\r\n";
	
	if(argc!=2) xerror("usage: oauthlr PORT");
	port=atoi(argv[1]);
	
#if WINDOWS_P
	{
		WSADATA wsadata;
		WSAStartup(MAKEWORD(2,0),&wsadata);
	}
#endif
	
	sock=socket(AF_INET,SOCK_STREAM,0);
	if(sock==INVALID_SOCKET) xerror("sock create failed");
	addr.sin_family=AF_INET;
	addr.sin_port=htons(port);
	addr.sin_addr.s_addr=INADDR_ANY;
	true=TRUE;
	setsockopt(sock,SOL_SOCKET,SO_REUSEADDR,(const char*)&true,sizeof(true));
	if(bind(sock,(struct sockaddr*)&addr,sizeof(addr))==SOCKET_ERROR) {
		xerror("bind failed");
	}
	
	if(listen(sock,SOMAXCONN)==SOCKET_ERROR) xerror("listen failed");
	
	len=sizeof(caddr);
	csock=accept(sock,(struct sockaddr*)&caddr,(socklen_t*)&len);
	if(csock==INVALID_SOCKET) xerror("accept failed");
	
	print_recv(csock);
	send(csock,send_data,sizeof(send_data),0);
	print_recv(csock);
	
	close_socket(csock);
	close_socket(sock);

#if WINDOWS_P	
	WSACleanup();
#endif
	return 0;
}
