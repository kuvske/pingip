unit Unit2;

interface

uses
  System.SysUtils, System.Classes, UniProvider, SQLServerUniProvider, Data.DB,
  MemDS, DBAccess, Uni, MySQLUniProvider, OracleUniProvider;

type
  Tdm = class(TDataModule)
    UniConnection1: TUniConnection;
    UniQuery1: TUniQuery;
    UniConnection2: TUniConnection;
    UniQuery2: TUniQuery;
    SQLServerUniProvider2: TSQLServerUniProvider;
    UniConnection3: TUniConnection;
    UniQuery3: TUniQuery;
    MySQLUniProvider1: TMySQLUniProvider;
    OracleUniProvider1: TOracleUniProvider;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
