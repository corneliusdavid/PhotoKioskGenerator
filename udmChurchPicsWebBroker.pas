unit udmChurchPicsWebBroker;

interface

uses
  System.SysUtils, System.Classes,
  Web.DBWeb, Web.HTTPApp, Web.HTTPProd;

type
  TdmChurchPicsWebBroker = class(TDataModule)
    PageProducer: TPageProducer;
  protected
  public
    { Public declarations }
  end;

var
  dmChurchPicsWebBroker: TdmChurchPicsWebBroker;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
