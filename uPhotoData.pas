unit uPhotoData;

interface

type
  TPhotoEntry = class
  private
    FID: Integer;
    FLastName: string;
    FParent1FirstName: string;
    FParent2FirstName: string;
    FChild1Name: string;
    FChild2Name: string;
    FChild3Name: string;
    FPhotoFilename: string;
  published
    property ID: Integer read FID write FID;
    property LastName: string read FLastName write FLastName;
    property Parent1FirstName: string read FParent1FirstName write FParent1FirstName;
    property Parent2FirstName: string read FParent2FirstName write FParent2FirstName;
    property Child1Name: string read FChild1Name write FChild1Name;
    property Child2Name: string read FChild2Name write FChild2Name;
    property Child3Name: string read FChild3Name write FChild3Name;
    property PhotoFilename: string read FPhotoFilename write FPhotoFilename;
  end;

implementation

end.
