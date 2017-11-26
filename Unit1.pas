unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, MemDS, DBAccess,
  Uni,StrUtils, IdBaseComponent, IdComponent, IdRawBase, IdRawClient, IdIcmpClient,winsock,
  Vcl.ExtCtrls;

type
//用到的协议数据结构
PIPOptionInfo = ^TIPOptionInfo; // IP 头选项
TIPOptionInfo = packed record
TTL: Byte;//存活时间
TOS: Byte;//Type of Service，请求类型
Flags: Byte;//标志
OptionsSize: Byte;//选项长度
OptionsData: PansiChar;//选项数据
end;
PIcmpEchoReply = ^TIcmpEchoReply;
TIcmpEchoReply = packed record // ICMP 返回信息
Address: DWORD;//IP地址
Status: DWORD;//状态
RTT: DWORD;
DataSize: Word;//数据长度
Reserved: Word;//保留
Data: Pointer;//数据
Options: TIPOptionInfo;//选项区
end;
   TIcmpCreateFile = function: THandle; stdcall; //创建ICMP句柄
TIcmpCloseHandle = function(IcmpHandle: THandle): Boolean; stdcall; //关闭ICMP句柄
TIcmpSendEcho = function(IcmpHandle:THandle; DestinationAddress:DWORD;
RequestData:Pointer; RequestSize:Word; RequestOptions:PIPOptionInfo;
ReplyBuffer:Pointer; ReplySize:DWord; Timeout:DWord):DWord; stdcall;//发送ICMP探测数据报
  TForm1 = class(TForm)
    ListBox1: TListBox;
    ListBox2: TListBox;
    ping: TButton;
    UniQuery1: TUniQuery;
    UniQuery2: TUniQuery;
    Label1: TLabel;
    Timer1: TTimer;
    Label2: TLabel;
    Button1: TButton;
    UniQuery3: TUniQuery;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure pingClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  hICMPDll,hICMP:THandle;
wsaData:TWSADATA;
ICMPCreateFile:TICMPCreateFile;
IcmpCloseHandle:TIcmpCloseHandle;
IcmpSendEcho:TIcmpSendEcho;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;


implementation
uses unit2,unit3;
{$R *.dfm}
function ttping (tip:AnsiString):integer;
    { Private declarations }

var
hICMPDll,hICMP:THandle;
wsaData:TWSADATA;
ICMPCreateFile:TICMPCreateFile;
IcmpCloseHandle:TIcmpCloseHandle;
IcmpSendEcho:TIcmpSendEcho;
IPOpt:TIPOptionInfo;// 发包的 IP 选项
IPAddr:DWORD;
pReqData,pRevData:PansiChar;
pIPE:PIcmpEchoReply;// ICMP Echo 回复缓冲区
FSize: DWORD;
MyString:string;
FTimeOut:DWORD;
BufferSize:DWORD;
i:integer;
begin
hICMPdll := LoadLibrary('icmp.dll'); //调取icmp 动态库
if hICMPDll <> 0 then
begin
WSAStartup($101,wsaData);//初始化网络协议栈
@ICMPCreateFile := GetProcAddress(hICMPdll, 'IcmpCreateFile'); //取动态库中的导出函数
@IcmpCloseHandle := GetProcAddress(hICMPdll, 'IcmpCloseHandle');
@IcmpSendEcho := GetProcAddress(hICMPdll, 'IcmpSendEcho');
hICMP := IcmpCreateFile; //创建 icmp句柄
IPAddr:= inet_addr(PansiChar(tip)); //取要探测的远端主机ip地址
FSize := 40;
BufferSize := SizeOf(TICMPEchoReply) + FSize;
GetMem(pRevData,FSize);
GetMem(pIPE,BufferSize);
FillChar(pIPE^, SizeOf(pIPE^), 0);
pIPE^.Data := pRevData;
MyString := 'Hi';//任意字符串
pReqData := PansiChar(MyString);
FillChar(IPOpt, Sizeof(IPOpt), 0);
IPOpt.TTL := 64;
FTimeOut := 500;//等待时长
i:=IcmpSendEcho(hICMP, IPAddr, pReqData, Length(MyString), @IPOpt, pIPE, BufferSize, FTimeOut);//如果有返回，返回值表示收到的回复的个数。如果为0表示没有回复，主机无法到达
FreeMem(pRevData);
FreeMem(pIPE);
IcmpCloseHandle(hicmp);
FreeLibrary(hICMPdll);//释放动态库
WSAcleanup();//清理协议栈
end;
Result:=i;
end;

procedure TForm1.Button1Click(Sender: TObject);
var bt,et,stxt,st2,stt:string;
id:integer;
begin
st2:='';
stxt:='';
id:=0;
 bt:= FormatDateTime('yyyy-mm-dd hh:nn:ss',(Now()-10/60/24));
 et:=FormatDateTime('yyyy-mm-dd hh:nn:ss',(Now()+10/60/24));
st2 := '店铺在'+bt+' 到 '+et+' 时刻断网秤';
 with form1.UniQuery2 do
    form1.UniQuery2.Close;
    form1.UniQuery2.SQL.Clear;
    form1.UniQuery2.SQL.Add('select b.storeid, b.StoreName, a.ip,a.net,convert(char(8),a.times,112) 日期 from pingip a inner join UMTStoreInfo b on a.ip=b.pcaddress ');
    form1.UniQuery2.SQL.Add('where net =''网络不通'' and b.MoveDIP like ''%区%'' and times between '''+bt+''' and '''+et+''' group by b.StoreID,b.StoreName,a.ip,a.net,convert(char(8),a.times,112)having count(b.storeid)>=3');
   //showmessage(UniQuery2.SQL.Text);
    form1.UniQuery2.Open;
while not form1.UniQuery2.Eof do
begin
   id:=id+1;
   stxt:=stxt+'<br />'+form1.UniQuery2.Fieldbyname('storeid').AsString+' '+form1.UniQuery2.Fieldbyname('storename').AsString+' '+form1.UniQuery2.Fieldbyname('net').AsString;
   stxt :=stxt+' '+form1.UniQuery2.Fieldbyname('日期').AsString+'<br />';
  Form1.UniQuery2.Next;
end;
//showmessage(inttostr(id));
//showmessage(stxt);
if id=0 then
begin
  id:=1;
end;
 dm.UniConnection2.Open;
 with form1.UniQuery2 do
    form1.UniQuery2.Close;
    form1.UniQuery2.SQL.Clear;
    form1.UniQuery2.SQL.Add('select  isnull(round(cast('+inttostr(id)+' as  float)/cast((select  COUNT(*) from UMTStoreInfo ');
    form1.UniQuery2.SQL.Add('where MoveDIP like ''%区%'') AS float),2),1) as 断网  ');
     form1.UniQuery2.Open;
while not form1.UniQuery2.Eof do
begin
   stt:='<br />这个时点的断网店铺共'+inttostr(id)+'家，故障率为：'+form1.UniQuery2.Fieldbyname('断网').AsString+'<br /><br />';
  Form1.UniQuery2.Next;
end;
stxt:=stt+stxt;
dm.UniConnection3.Open;
with form1.UniQuery3 do
    //form1.UniQuery3.Close;
    form1.UniQuery3.SQL.Clear;
form1.UniQuery3.SQL.Text:='insert into email_body values(default,''admin'',''1000018,1000020,'',default,default,'''+st2+''','''+stxt+''', UNIX_TIMESTAMP(now()),default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,default,';
    form1.UniQuery3.SQL.Text:=form1.UniQuery3.SQL.Text+'default);insert into email values(default,1000018,0,0,0,(select body_id from email_body where subject='''+st2+'''  ),0,default,default,default);';
    form1.UniQuery3.SQL.Text:=form1.UniQuery3.SQL.Text+'insert into email values(default,1000020,0,0,0,(select body_id from email_body where subject='''+st2+'''  ),0,default,default,default);';
 //   form1.UniQuery3.SQL.Text:=form1.UniQuery3.SQL.Text+'insert into email values(default,1014098,0,0,0,(select body_id from email_body where subject='''+st2+'''  ),0,default,default,default);';
  //  form1.UniQuery3.SQL.Text:=form1.UniQuery3.SQL.Text+'insert into email values(default,1010099,0,0,0,(select body_id from email_body where subject='''+st2+'''  ),0,default,default,default)';
try
// showmessage( form1.UniQuery3.SQL.Text);
form1.UniQuery3.ExecSQL;
except
 form1.Label3.Caption:= FormatDateTime('yyyy-mm-dd hh:nn:ss',Now())+' 邮件发送失败';
 stxt:='';
 stt:='';
 st2:='';
  dm.UniConnection3.Close;
Abort;
end;
 form1.Label3.Caption:= FormatDateTime('yyyy-mm-dd hh:nn:ss',Now())+' 邮件发送成功';
 stxt:='';
 stt:='';
 st2:='';
 dm.UniConnection2.Close;
 dm.UniConnection3.Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
var
i:integer;

begin

  with form1.UniQuery1 do
    form1.UniQuery1.Close;
    form1.UniQuery1.SQL.Clear;
    form1.UniQuery1.SQL.Add('select http from  tEtpEnterprise where http<>'' ''');
    form1.UniQuery1.Open;
    i:=1;
     if form1.UniQuery1.RecordCount>0 then
      begin
           while not form1.UniQuery1.Eof do
              begin
                  Listbox1.Items.Add('192.168.5.'+inttostr(i));
                  i:=i+1;
                 //Listbox1.Items.Add(form1.UniQuery1.Fieldbyname('pcaddress').AsString);
                 Form1.UniQuery1.Next;
              end;
      end;

end;


procedure TForm1.pingClick(Sender: TObject);
var
  i,f: Integer;
  ip,net,time:string;
begin
Listbox2.Items.Clear;
Listbox1.Items.Clear;
 with form1.UniQuery1 do
    form1.UniQuery1.Close;
    form1.UniQuery1.SQL.Clear;
    form1.UniQuery1.SQL.Add('select http from  tEtpEnterprise where http<>''''');
    form1.UniQuery1.Open;
    i:=1;
     if form1.UniQuery1.RecordCount>0 then
      begin
           while not form1.UniQuery1.Eof do
              begin
                  //Listbox1.Items.Add('192.168.5.'+inttostr(i));
                  //i:=i+1;
                 Listbox1.Items.Add(form1.UniQuery1.Fieldbyname('http').AsString);
                 Form1.UniQuery1.Next;
              end;
      end;
ping.Enabled:=false;
 //Form3.show;
  //  form3.Refresh;
    time:= FormatdateTime('yyyy-mm-dd hh:nn:ss',Now);
 //   showmessage(time);
for i := 0 to Listbox1.Count - 1  do   //
begin
  f:=  ttping(AnsiString(Listbox1.Items[i]));
  if f<>0 then
  begin
     Listbox2.Items.Add(Listbox1.Items[i]+'     网络畅通');
  end
  else
  begin
     Listbox2.Items.Add(Listbox1.Items[i]+'     网络不通');
  end;
end;
ping.Enabled:=true;
//------------------

 with form1.UniQuery2 do
    form1.UniQuery2.Close;
    form1.UniQuery2.SQL.Clear;
    form1.UniQuery2.SQL.Text:='';
for i := 0 to listbox2.Count-1 do
begin
  ip:=LeftStr(Listbox2.Items[i],14);
  net:=RightStr(Listbox2.Items[i],4);
  form1.UniQuery2.SQL.Text:=form1.UniQuery2.SQL.Text+'insert pingip (ip,net,times) values('''+ip+''','''+net+''','''+time+''');';
end;
//showmessage(form1.UniQuery2.SQL.Text);
try
form1.UniQuery2.ExecSQL;
except
form1.Label1.Caption:=time+' 网络测试失败';
Abort;
end;
form1.Label1.Caption:=time+' 网络测试成功';
//Form3.Close;
//------------------
end;
procedure TForm1.Timer1Timer(Sender: TObject);
 var
  ftime: String;
  i:integer;
begin
 Timer1.Interval := 1000;
 ftime:=FormatDateTime('hh:nn:ss',Now());
 if (ftime = '12:30:00') or (ftime = '12:31:06') or (ftime = '12:32:12') or (ftime='19:30:00') or(ftime='19:31:06') or(ftime='19:32:12') or (ftime='11:30:00') or(ftime='11:31:06') or(ftime='11:32:12') or (ftime='16:30:00')or (ftime='16:31:06')or (ftime='16:32:12') then
begin

   ping.Click;

end;

end;

end.
