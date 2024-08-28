/// OpenAPI Client Code Generation
// - this unit is a part of the Open Source Synopse mORMot framework 2,
// licensed under a MPL/GPL/LGPL three license - see LICENSE.md
unit mormot.net.openapi;

{
  *****************************************************************************

  OpenAPI Language-agnostic Interface to HTTP APIs
  - OpenAPI Document Wrappers
  - FPC/Delphi Pascal Client Code Generation

  *****************************************************************************
}

interface

{$I ..\mormot.defines.inc}

uses
  sysutils,
  classes,
  mormot.core.base,
  mormot.core.os,
  mormot.core.unicode,
  mormot.core.text,
  mormot.core.data, // for TRawUtf8List
  mormot.core.variants,
  mormot.rest.core;


{ ************************************ OpenAPI Document Wrappers }

const
  SCHEMA_TYPE_ARRAY: RawUtf8 = 'array';
  SCHEMA_TYPE_OBJECT: RawUtf8 = 'object';

type
  /// exception class raised by this Unit
  EOpenApi = class(ESynException);

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Schema
  POpenApiSchema = ^TOpenApiSchema;

  /// high-level OpenAPI Schema wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiSchema = record
  {$else}
  TOpenApiSchema = object
  {$endif USERECORDWITHMETHODS}
  private
    function GetPropertyByName(const aName: RawUtf8): POpenApiSchema;
  public
    /// transtype the POpenApiSchema pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Schema information
    function _Type: RawUtf8;
    function _Format: RawUtf8;
    function Required: PDocVariantData;
    function Enum: PDocVariantData;
    function Nullable: boolean;
    function Description: RawUtf8;
    function Example: variant;
    function Reference: RawUtf8;
    function AllOf: PDocVariantData;
    function Items: POpenApiSchema;
    function Properties: PDocVariantData;
    property _Property[const aName: RawUtf8]: POpenApiSchema
      read GetPropertyByName;
    // high-level OpenAPI Schema Helpers
    function IsArray: boolean;
    function IsObject: boolean;
    function IsNamedEnum: boolean;
    function BuiltinType: RawUtf8;
  end;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Response
  POpenApiResponse = ^TOpenApiResponse;
  /// high-level OpenAPI Schema wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiResponse = record
  {$else}
  TOpenApiResponse = object
  {$endif USERECORDWITHMETHODS}
  public
    /// transtype the POpenApiResponse pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Response information
    function Description: RawUtf8;
    function Schema: POpenApiSchema;
  end;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Parameter
  POpenApiParameter = ^TOpenApiParameter;
  /// high-level OpenAPI Parameter wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiParameter = record
  {$else}
  TOpenApiParameter = object
  {$endif USERECORDWITHMETHODS}
  public
    /// transtype the POpenApiParameter pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Parameter information
    function AsSchema: POpenApiSchema;
    function Name: RawUtf8;
    function AsPascalName: RawUtf8;
    function _In: RawUtf8;
    function AllowEmptyValues: boolean;
    function Default: PVariant;
    /// true if Default or not Required
    function HasDefaultValue: boolean;
    function Required: boolean;
    function Schema: POpenApiSchema;
  end;
  /// a dynamic array of pointers wrapper to OpenAPI Parameter(s)
  POpenApiParameterDynArray = array of POpenApiParameter;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Parameters
  POpenApiParameters = ^TOpenApiParameters;
  /// high-level OpenAPI Parameter wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiParameters = record
  {$else}
  TOpenApiParameters = object
  {$endif USERECORDWITHMETHODS}
  private
    function GetParameterByIndex(aIndex: integer): POpenApiParameter;
      {$ifdef HASINLINE} inline; {$endif}
  public
    /// transtype the POpenApiParameters pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Parameters information
    function Count: integer;
    property Parameter[aIndex: integer]: POpenApiParameter
      read GetParameterByIndex;
  end;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Operation
  POpenApiOperation = ^TOpenApiOperation;
  /// high-level OpenAPI Operation wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiOperation = record
  {$else}
  TOpenApiOperation = object
  {$endif USERECORDWITHMETHODS}
  private
    function GetResponseForStatusCode(aStatusCode: integer): POpenApiResponse;
  public
    /// transtype the POpenApiOperation pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Operation information
    function Id: RawUtf8;
    function Summary: RawUtf8;
    function Description: RawUtf8;
    function Tags: TRawUtf8DynArray;
    function Deprecated: boolean;
    function Parameters: POpenApiParameters;
    function PayloadParameter: POpenApiParameter;
    function Responses: PDocVariantData;
    property Response[aStatusCode: integer]: POpenApiResponse
      read GetResponseForStatusCode;
  end;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Path Item
  POpenApiPathItem = ^TOpenApiPathItem;
  /// high-level OpenAPI Path Item wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiPathItem = record
  {$else}
  TOpenApiPathItem = object
  {$endif USERECORDWITHMETHODS}
  private
    function GetOperationByMethod(aMethod: TUriMethod): POpenApiOperation;
  public
    /// transtype the POpenApiPathItem pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Path Item information
    function Summary: RawUtf8;
    function Description: RawUtf8;
    function Parameters: POpenApiParameters;
    property Method[aMethod: TUriMethod]: POpenApiOperation
      read GetOperationByMethod;
  end;

  /// pointer wrapper to TDocVariantData / variant content of an OpenAPI Tag
  POpenApiTag = ^TOpenApiTag;
  /// high-level OpenAPI Tag wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiTag = record
  {$else}
  TOpenApiTag = object
  {$endif USERECORDWITHMETHODS}
  public
    /// transtype the POpenApiTag pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Tag information
    function Description: RawUtf8;
    function Name: RawUtf8;
  end;

  /// pointer wrapper to TDocVariantData / variant content of OpenAPI Specs
  POpenApiSpecs = ^TOpenApiSpecs;
  /// high-level OpenAPI Specs wrapper to TDocVariantData / variant content
  {$ifdef USERECORDWITHMETHODS}
  TOpenApiSpecs = record
  {$else}
  TOpenApiSpecs = object
  {$endif USERECORDWITHMETHODS}
  private
    function GetDefinitionByName(const aName: RawUtf8): POpenApiSchema;
    function GetPathItemByName(const aPath: RawUtf8): POpenApiPathItem;
  public
    /// transtype the POpenApiSpecs pointer into a TDocVariantData content
    Data: TDocVariantData;
    // access to the OpenAPI Specs information
    function BasePath: RawUtf8;
    function Definitions: PDocVariantData;
    function Paths: PDocVariantData;
    function Tags: PDocVariantData;
    function Version: RawUtf8;
    property Definition[const aName: RawUtf8]: POpenApiSchema
      read GetDefinitionByName;
    property Path[const aPath: RawUtf8]: POpenApiPathItem
      read GetPathItemByName;
  end;


{ ************************************ FPC/Delphi Pascal Client Code Generation }

type
  TOpenApiParser = class;
  TPascalCustomType = class;

  /// define any Pascal type, as basic type of custom type
  TPascalType = class
  private
    fBuiltinSchema: POpenApiSchema;
    fBuiltinTypeName: RawUtf8;
    fCustomType: TPascalCustomType;
    fIsArray: boolean;
    fIsParent: boolean;
    function GetSchema: POpenApiSchema;
    procedure SetArray(AValue: boolean);
  public
    constructor CreateBuiltin(const aBuiltinTypeName: RawUtf8;
      aSchema: POpenApiSchema = nil; aIsArray: boolean = false); overload;
    constructor CreateCustom(aCustomType: TPascalCustomType;
      aIsArray: boolean = false; aIsParent: boolean = false); overload;

    class function LoadFromSchema(Parser: TOpenApiParser;
      Schema: POpenApiSchema): TPascalType;

    // TODO: Handle RecordArrayType in RTTI definition
    function ToPascalName(AllowArrayType: boolean = true;
      NoRecordArrayTypes: boolean = false): RawUtf8;
    function ToFormatUtf8Arg(const VarName: RawUtf8): RawUtf8;
    function ToDefaultParameterValue(aParam: POpenApiParameter): RawUtf8;

    function IsBuiltin: boolean;
    function IsEnum: boolean;
    function IsRecord: boolean;
    property IsArray: boolean
      read fIsArray write SetArray;
    property IsParent: boolean
      read fIsParent;

    property CustomType: TPascalCustomType
      read fCustomType;
    property Schema: POpenApiSchema
      read GetSchema;
  end;

  /// define a Pascal property
  TPascalProperty = class
  private
    fType: TPascalType;
    fSchema: POpenApiSchema;
    fName: RawUtf8;
    fPascalName: RawUtf8;
  public
    class function SanitizePropertyName(const aName: RawUtf8): RawUtf8;
    constructor Create(const aName: RawUtf8;
      aSchema: POpenApiSchema; aType: TPascalType);
    destructor Destroy; override;
    constructor CreateFromSchema(aOwner: TOpenApiParser; const aName: RawUtf8;
      aSchema: POpenApiSchema; ParentField: boolean = false);
    property PropType: TPascalType
      read fType;
    property Schema: POpenApiSchema
      read fSchema;
    property Name: RawUtf8
      read fName;
  end;

  /// abstract parent class holder for complex types
  TPascalCustomType = class
  private
    fName: RawUtf8;
    fPascalName: RawUtf8;
    fSchema: POpenApiSchema;
    fParser: TOpenApiParser;
    fRequiresArrayDefinition: boolean;
  public
    constructor Create(aOwner: TOpenApiParser; const aPascalName: RawUtf8 = '');
    function ToTypeDefinition(const LineIndentation: RawUtf8 = ''): RawUtf8; virtual; abstract;
    function ToArrayTypeName(AllowArrayType: boolean = true): RawUtf8; virtual;
    function ToArrayTypeDefinition(const LineIndentation: RawUtf8 = ''): RawUtf8; virtual;
    property Name: RawUtf8
      read fName;
    property PascalName: RawUtf8
      read fPascalName;
    property Schema: POpenApiSchema
      read fSchema;
  end;

  /// define a Pascal data structure, as a packed record with RTTI
  TPascalRecord = class(TPascalCustomType)
  private
    fProperties: TRawUtf8List; // Objects are owned TPascalProperty
    fDependencies: TRawUtf8DynArray;
  public
    constructor Create(aOwner: TOpenApiParser; const SchemaName: RawUtf8;
      Schema: POpenApiSchema = nil);
    destructor Destroy; override;
    function ToTypeDefinition(const LineIndentation: RawUtf8 = ''): RawUtf8; override;
    function ToRttiTextRepresentation(WithClassName: boolean = true): RawUtf8;
    function ToRttiRegisterDefinitions: RawUtf8;
    property Properties: TRawUtf8List
      read fProperties;
  end;
  TPascalRecordDynArray = array of TPascalRecord;

  /// define a Pascal enumeration type
  TPascalEnum = class(TPascalCustomType)
  private
    fPrefix: RawUtf8;
    fChoices: TDocVariantData;
  public
    constructor Create(aOwner: TOpenApiParser; const SchemaName: RawUtf8;
      aSchema: POpenApiSchema);
    function ToTypeDefinition(const LineIndentation: RawUtf8 = ''): RawUtf8; override;
    function ToArrayTypeName(AllowArrayType: boolean = true): RawUtf8; override;
    function ToConstTextArrayName: RawUtf8;
    function ToConstTextArray: RawUtf8;
    property Prefix: RawUtf8
      read fPrefix;
  end;

  /// define a Pascal method matching an OpenAPI operation
  TPascalOperation = class
  private
    fPath: RawUtf8;
    fPathItem: POpenApiPathItem;
    fOperation: POpenApiOperation;
    fMethod: TUriMethod;
    fPayloadParameterType: TPascalType;
    fSuccessResponseType: TPascalType;
    fSuccessResponseCode: integer;
  public
    constructor Create(const aPath: RawUtf8; aPathItem: POpenApiPathItem;
      aOperation: POpenApiOperation; aMethod: TUriMethod);
    destructor Destroy; override;
    // Resolve parameters/responses types
    procedure ResolveTypes(Parser: TOpenApiParser);
    function GetAllParameters: POpenApiParameterDynArray;
    function Documentation(const LineEnd, LineIndent: RawUtf8): RawUtf8;
    function Declaration(const ClassName: RawUtf8; Parser: TOpenApiParser): RawUtf8;
    function Body(const ClassName, BasePath: RawUtf8; Parser: TOpenApiParser): RawUtf8;
    function FunctionName: RawUtf8;
  end;
  TPascalOperationDynArray = array of TPascalOperation;

  TPascalOperationsByTag = record
    TagName: RawUtf8;
    Tag: POpenApiTag;
    Operations: TPascalOperationDynArray;
  end;
  TPascalOperationsByTagDynArray = array of TPascalOperationsByTag;

  /// the main OpenAPI parser and pascal code generator class
  TOpenApiParser = class
  private
    fSpecs: TDocVariantData;
    fRecords: TRawUtf8List; // objects are owned TPascalRecord
    fEnums: TRawUtf8List;   // objects are owned TPascalEnum
    fOperations: TPascalOperationDynArray;
    fLineEnd: RawUtf8;
    procedure ParseSpecs;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure ParseFile(const aJsonFile: TFileName);
    procedure ParseJson(const aJson: RawUtf8);
    procedure Parse(const aSpecs: TDocVariantData);
    procedure ExportToDirectory(Name: RawUtf8; DirectoryName: RawUtf8 = './'; UnitPrefix: RawUtf8 = '');
    function ParseDefinition(const aDefinitionName: RawUtf8): TPascalRecord;
    procedure ParsePath(const aPath: RawUtf8);

    function GetRecord(aRecordName: RawUtf8;
      NameIsReference: boolean = false): TPascalRecord;
    function GetOrderedRecords: TPascalRecordDynArray;
    function GetOperationsByTag: TPascalOperationsByTagDynArray;

    procedure Dump;
    function GetDtosUnit(const UnitName: RawUtf8): RawUtf8;
    function GetClientUnit(const UnitName, ClientClassName, DtoUnitName: RawUtf8): RawUtf8;
    function Specs: POpenApiSpecs;
    function Info: PDocVariantData;
    property Operations: TPascalOperationDynArray
      read fOperations;
    property LineEnd: RawUtf8
      read fLineEnd;
  end;


const
  // published for unit testing (e.g. if properly sorted)
  RESERVED_KEYWORDS: array[0..73] of RawUtf8 = (
    'absolute', 'and', 'array', 'as', 'asm', 'begin', 'case', 'const',
    'constructor', 'destructor', 'div', 'do', 'else', 'end', 'except',
    'exports', 'external', 'false', 'far', 'file', 'finalization', 'finally',
    'for', 'forward', 'function', 'goto', 'if', 'implementation', 'in',
    'inherited', 'initialization', 'interface', 'is', 'label',
    'library', 'mod', 'near', 'new', 'nil', 'not', 'object', 'of', 'on',
    'operator', 'or', 'override', 'packed', 'procedure', 'program', 'property',
    'protected', 'public', 'published', 'raise', 'read', 'reintroduce',
    'repeat', 'self', 'shl', 'shr', 'then', 'threadvar', 'to', 'true', 'try',
    'type', 'unit', 'uses', 'var', 'virtual', 'while', 'with', 'write', 'xor');

/// quickly check if a text is a case-insensitive pascal code keyword
function IsReservedKeyWord(const aName: RawUtf8): boolean;


implementation


{ ************************************ OpenAPI Document Wrappers }

{ TOpenApiSchema }

function TOpenApiSchema.AllOf: PDocVariantData;
begin
  if not Data.GetAsArray('allOf', result) then
    result := nil;
end;

function TOpenApiSchema.Items: POpenApiSchema;
begin
  if not IsArray then
    EOpenApi.RaiseUtf8('Trying to access items field on a non array schema: %', [_Type]);
  if not Data.GetAsObject('items', PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiSchema.Properties: PDocVariantData;
begin
  if not Data.GetAsObject('properties', result) then
    result := nil;
end;

function TOpenApiSchema.GetPropertyByName(const aName: RawUtf8): POpenApiSchema;
begin
  if not Properties^.GetAsObject(aName, PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiSchema.Reference: RawUtf8;
begin
  result := Data.U['$ref']
end;

function TOpenApiSchema.Nullable: boolean;
begin
  result := Data.B['nullable'];
end;

function TOpenApiSchema.Required: PDocVariantData;
begin
  result := Data.A['required']
end;

function TOpenApiSchema.Description: RawUtf8;
begin
  result := Data.U['description']
end;

function TOpenApiSchema.Enum: PDocVariantData;
begin
  if not Data.GetAsArray('enum', result) then
    result := nil;
end;

function TOpenApiSchema.Example: variant;
begin
  result := Data.Value['example'];
end;

function TOpenApiSchema._Format: RawUtf8;
begin
  result := Data.U['format'];
end;

function TOpenApiSchema._Type: RawUtf8;
begin
  result := Data.U['type'];
end;

function TOpenApiSchema.IsArray: boolean;
begin
  result := _Type = SCHEMA_TYPE_ARRAY;
end;

function TOpenApiSchema.IsObject: boolean;
begin
  result := _Type = SCHEMA_TYPE_OBJECT;
end;

function TOpenApiSchema.IsNamedEnum: boolean;
begin
  result := (Enum <> nil) and
            (_Format <> '');
end;

function TOpenApiSchema.BuiltinType: RawUtf8;
var
  t, f: RawUtf8;
begin
  t := _Type;
  f := _Format;
  if t = 'integer' then
    if f = 'int64' then
      result := 'Int64'
    else
      result := 'integer'
  else if t = 'number' then
    if f = 'float' then
      result := 'Single'
    else
      result := 'Double'
  else if t = 'string' then
    if f = 'date' then
      result := 'TDate'
    else if f = 'date-time' then
      result := 'TDateTime'
    else if f = 'uuid' then
      result := 'TGuid'
    else if f = 'binary' then
      result := 'RawByteString'
    else if f = 'password' then
      result := 'SpiUtf8'
    else
      result := 'RawUtf8'
  else if t = 'boolean' then
    result := 'boolean'
  else
    result := 'TDocVariantData';
end;


{ TOpenApiResponse }

function TOpenApiResponse.Description: RawUtf8;
begin
  result := Data.U['description'];
end;

function TOpenApiResponse.Schema: POpenApiSchema;
begin
  result := POpenApiSchema(Data.O['schema']);
end;



{ TOpenApiParameter }

function TOpenApiParameter.AllowEmptyValues: boolean;
begin
  result := Data.B['allowEmptyValue'];
end;

function TOpenApiParameter.AsSchema: POpenApiSchema;
begin
  result := POpenApiSchema(@self);
end;

function TOpenApiParameter.Default: PVariant;
begin
  result := Data.GetPVariantByPath('default');
end;

function TOpenApiParameter.HasDefaultValue: boolean;
begin
  result := (Default <> nil) or not Required;
end;

function TOpenApiParameter._In: RawUtf8;
begin
  result := Data.U['in'];
end;

function TOpenApiParameter.Name: RawUtf8;
begin
  result := Data.U['name'];
end;

function TOpenApiParameter.Required: boolean;
begin
  result := Data.B['required'];
end;

function TOpenApiParameter.Schema: POpenApiSchema;
begin
  if not Data.GetAsObject('schema', PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiParameter.AsPascalName: RawUtf8;
begin
  result := TPascalProperty.SanitizePropertyName(Name);
end;


{ TOpenApiTag }

function TOpenApiTag.Description: RawUtf8;
begin
  if @self = nil then
    result := ''
  else
    result := Data.U['description'];
end;

function TOpenApiTag.Name: RawUtf8;
begin
  result := Data.U['name'];
end;


{ TOpenApiPathItem }

function TOpenApiPathItem.Description: RawUtf8;
begin
  result := Data.U['description'];
end;

function TOpenApiPathItem.GetOperationByMethod(aMethod: TUriMethod): POpenApiOperation;
begin
  if not Data.GetAsObject(ToText(aMethod), PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiPathItem.Parameters: POpenApiParameters;
begin
  result := POpenApiParameters(Data.A['parameters']);
end;

function TOpenApiPathItem.Summary: RawUtf8;
begin
  result := Data.U['summary'];
end;


{ TOpenApiParameters }

function TOpenApiParameters.GetParameterByIndex(aIndex: integer): POpenApiParameter;
begin
  if cardinal(aIndex) >= cardinal(Data.Count) then
    EOpenApi.RaiseUtf8('Out of range TOpenApiParameters[%]', [aIndex]);
  result := @Data.Values[aIndex];
end;

function TOpenApiParameters.Count: integer;
begin
  result := Data.Count;
end;


{ TOpenApiOperation }

function TOpenApiOperation.Deprecated: boolean;
begin
  result := Data.B['deprecated'];
end;

function TOpenApiOperation.Description: RawUtf8;
begin
  result := Data.U['description'];
end;

function TOpenApiOperation.Id: RawUtf8;
begin
  result := Data.U['operationId'];
end;

function TOpenApiOperation.Parameters: POpenApiParameters;
begin
  result := POpenApiParameters(Data.A['parameters']);
end;

function TOpenApiOperation.PayloadParameter: POpenApiParameter;
var
  p: POpenApiParameters;
  i: PtrInt;
begin
  p := Parameters;
  if p <> nil then
    for i := 0 to p.Count - 1 do
    begin
      result := p.Parameter[i];
      if (result^._In = 'body') and
         (result^.Name = 'payload') then
        exit;
    end;
  result := nil;
end;

function TOpenApiOperation.GetResponseForStatusCode(
  aStatusCode: integer): POpenApiResponse;
var
  nam: RawUtf8;
begin
  if aStatusCode = 0 then
    nam := 'default'
  else
    UInt32ToUtf8(aStatusCode, nam);
  if not Responses^.GetAsObject(nam, PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiOperation.Responses: PDocVariantData;
begin
  result := Data.O['responses'];
end;

function TOpenApiOperation.Summary: RawUtf8;
begin
  result := Data.U['summary'];
end;

function TOpenApiOperation.Tags: TRawUtf8DynArray;
begin
  Data.A['tags']^.ToRawUtf8DynArray(result);
end;


{ TOpenApiSpecs }

function TOpenApiSpecs.GetDefinitionByName(const aName: RawUtf8): POpenApiSchema;
begin
  if not Definitions^.GetAsObject(aName, PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiSpecs.GetPathItemByName(const aPath: RawUtf8): POpenApiPathItem;
begin
  if not Paths^.GetAsObject(aPath, PDocVariantData(result)) then
    result := nil;
end;

function TOpenApiSpecs.BasePath: RawUtf8;
begin
  result := Data.U['basePath'];
end;

function TOpenApiSpecs.Definitions: PDocVariantData;
begin
  result := Data.O['definitions'];
end;

function TOpenApiSpecs.Paths: PDocVariantData;
begin
  result := Data.O['paths'];
end;

function TOpenApiSpecs.Tags: PDocVariantData;
begin
  result := Data.A['tags'];
end;

function TOpenApiSpecs.Version: RawUtf8;
begin
  if not Data.GetAsRawUtf8('swagger', result) then
    result := Data.U['openapi'];
end;



{ ************************************ FPC/Delphi Pascal Code Generation }

{ TPascalCustomType }

constructor TPascalCustomType.Create(aOwner: TOpenApiParser;
  const aPascalName: RawUtf8);
begin
  fParser := aOwner;
  fPascalName := aPascalName;
end;

function TPascalCustomType.ToArrayTypeName(AllowArrayType: boolean): RawUtf8;
begin
  if AllowArrayType then
    result := FormatUtf8('%DynArray', [PascalName])
  else
    result := FormatUtf8('array of %', [PascalName]);
end;

function TPascalCustomType.ToArrayTypeDefinition(const LineIndentation: RawUtf8): RawUtf8;
begin
  if fRequiresArrayDefinition then
    result := FormatUtf8('%% = %;'#10, [LineIndentation,
    ToArrayTypeName(true), ToArrayTypeName(false)])
  else
    result := '';
end;


{ TPascalOperation }

constructor TPascalOperation.Create(const aPath: RawUtf8;
  aPathItem: POpenApiPathItem; aOperation: POpenApiOperation; aMethod: TUriMethod);
begin
  fPath := aPath;
  fPathItem := aPathItem;
  fOperation := aOperation;
  fMethod := aMethod;
end;

destructor TPascalOperation.Destroy;
begin
  fPayloadParameterType.Free;
  fSuccessResponseType.Free;
  inherited Destroy;
end;

procedure TPascalOperation.ResolveTypes(Parser: TOpenApiParser);
var
  p: POpenApiParameter;
  cod: integer;
  v: PDocVariantData;
  i: PtrInt;
begin
  p := fOperation^.PayloadParameter;
  if Assigned(p) then
    fPayloadParameterType := TPascalType.LoadFromSchema(Parser, p^.Schema);
  v := fOperation.Responses;
  for i := 0 to v^.Count - 1 do
  begin
    cod := Utf8ToInteger(v^.Names[i], 0);
    if (v^.Names[i] = 'default') or
       ((cod >= 200) and (cod < 400)) then
    begin
      fSuccessResponseCode := cod;
      fSuccessResponseType := TPascalType.LoadFromSchema(
        Parser, POpenApiResponse(@v^.Values[i])^.Schema);
      break; // use the first success
    end;
  end;
end;

function TPascalOperation.GetAllParameters: POpenApiParameterDynArray;
var
  p, o: POpenApiParameters;
  pn, i: integer;
begin
  p := fPathItem^.Parameters;
  pn := p.Count;
  o := fOperation^.Parameters;
  SetLength(result, pn + o.Count);
  for i := 0 to pn - 1 do
    result[i] := p^.Parameter[i];
  for i := 0 to o.Count - 1 do
    result[pn + i] := o^.Parameter[i];
end;

function TPascalOperation.Documentation(const LineEnd: RawUtf8;
  const LineIndent: RawUtf8): RawUtf8;
var
  params: POpenApiParameterDynArray;
  p: POpenApiParameter;
  v: PDocVariantData;
  status: RawUtf8;
  code: integer;
  r: POpenApiResponse;
  i: PtrInt;
begin
  result := FormatUtf8('%// [%] %%', [LineIndent, ToText(fMethod), fPath, LineEnd]);

  // Summary
  if fOperation^.Summary <> '' then
    Append(result, [LineIndent, '// Summary: ', fOperation^.Summary, LineEnd]);
  // Description
  if fOperation^.Description <> '' then
    Append(result, [LineIndent, '// Description:', LineEnd,
      LineIndent, '//   ', StringReplaceAll(fOperation^.Description, LineEnd,
        FormatUtf8('%%//   ', [LineEnd + LineIndent])), LineEnd]);
  // params
  params := GetAllParameters;
  if params <> nil then
  begin
    Append(result, [LineIndent, '//', LineEnd,
                    LineIndent, '// params:', LineEnd]);
    for i := 0 to high(params) do
    begin
      p := params[i];
      Append(result, [LineIndent, '// - [', p^._In, '] ', p^.AsPascalName]);
      if p^.Required then
        Append(result, '*');
      if p^.Default <> nil then
        Append(result, [' (default=', p^.Default^, ')']);
      if p^.AsSchema^.Description <> '' then
        Append(result, ': ', p^.AsSchema^.Description);
      Append(result, LineEnd);
    end;
  end;
  // Responses
  v := fOperation^.Responses;
  if v^.Count > 0 then
  begin
    Append(result, [LineIndent, '//', LineEnd,
                    LineIndent, '// Responses:', LineEnd]);
    v^.SortByName(@StrCompByNumber); // sort by status number
    for i := 0 to v^.Count - 1 do
    begin
      status := v^.Names[i];
      code := Utf8ToInteger(status, 0);
      Append(result, [LineIndent, '// - ', status]);
      if code = fSuccessResponseCode then
        Append(result, '*');
      r := @v^.Values[i];
      if r^.Description <> '' then
        Append(result, [': ', r^.Description, LineEnd])
      else
        Append(result, ': No Description', LineEnd);
    end;
  end;
end;

function TPascalOperation.Declaration(const ClassName: RawUtf8;
  Parser: TOpenApiParser): RawUtf8;
var
  params: POpenApiParameterDynArray;
  p: POpenApiParameter;
  pt: TPascalType;
  i, ndx: PtrInt;
  def: TRawUtf8DynArray;
begin
  if Assigned(fSuccessResponseType) then
    result := 'function '
  else
    result := 'procedure ';

  if ClassName <> '' then
    Append(result, ClassName, '.');
  Append(result, FunctionName, '(');

  params := GetAllParameters;
  ndx := 0;
  for i := 0 to Length(params) - 1 do
  begin
    p := params[i];
    if (p^._In = 'path') or
       (p^._In = 'query') then
    begin
      if not p^.HasDefaultValue then
      begin
        if (ndx > 0) then
          Append(result, '; ');
        inc(ndx);
      end;
      pt := TPascalType.LoadFromSchema(Parser, p^.AsSchema);
      try
        if p^.HasDefaultValue then
          AddRawUtf8(def, FormatUtf8('%: % = %', [p^.AsPascalName,
              pt.ToPascalName, pt.ToDefaultParameterValue(p)]))
        else
          Append(result, [p^.AsPascalName, ': ', pt.ToPascalName]);
      finally
        pt.Free;
      end;
    end;
  end;

  if Assigned(fPayloadParameterType) then
  begin
    if ndx > 0 then
      Append(result, '; const payload: ', fPayloadParameterType.ToPascalName)
    else
      Append(result, 'const payload: ', fPayloadParameterType.ToPascalName);
    inc(ndx);
  end;

  for i := 0 to high(def) do
  begin
    if ndx <> 0 then
      Append(result, '; ');
    Append(result, def[i]);
    inc(ndx);
  end;

  if Assigned(fSuccessResponseType) then
    Append(result, ['): ', fSuccessResponseType.ToPascalName, ';'])
  else
    Append(result, ');');
end;

function TPascalOperation.Body(const ClassName, BasePath: RawUtf8;
  Parser: TOpenApiParser): RawUtf8;
var
  Action: RawUtf8;
  ActionArgs: TRawUtf8DynArray;
  i: PtrInt;
  QueryParameters: TDocVariantData;
  Parameters: POpenApiParameterDynArray;
  Param: POpenApiParameter;
  ParamType: TPascalType;
begin
  Action := BasePath + fPath;
  ActionArgs := nil;
  QueryParameters.InitObject([], JSON_FAST);

  Parameters := GetAllParameters;
  for i := 0 to high(Parameters) do
  begin
    Param := Parameters[i];
    ParamType := TPascalType.LoadFromSchema(Parser, Param^.AsSchema);
    try
      if Param^._In = 'path' then
      begin
        Action := StringReplaceAll(Action, FormatUtf8('{%}', [Param^.Name]), '%');
        AddRawUtf8(ActionArgs, ParamType.ToFormatUtf8Arg(Param^.AsPascalName));
      end
      else if Param^._In = 'query' then
      begin
        QueryParameters.AddValue(Param^.Name, ParamType.ToFormatUtf8Arg(Param^.AsPascalName));
      end;
    finally
      ParamType.Free;
    end;
  end;

   result := FormatUtf8('%%begin%  JsonClient.Request(''%'', ''%''',
     [Declaration(ClassName, Parser), Parser.LineEnd, Parser.LineEnd,
      ToText(fMethod), Action]);
   // Path parameters
   if Length(ActionArgs) > 0 then
   begin
     Append(result, ', [');
     for i := 0 to Length(ActionArgs) - 1 do
     begin
       if i > 0 then
         Append(result, ', ');
       Append(result, ActionArgs[i]);
     end;
     Append(result, ']');
   end
   // Either ActionArgs and QueryArgs or None of them (for Request parameters)
   else if (QueryParameters.Count > 0) or Assigned(fPayloadParameterType) then
     Append(result, ', []');

   // Query parameters
   if QueryParameters.Count > 0 then
   begin
     Append(result, ', [', Parser.LineEnd);
     for i := 0 to QueryParameters.Count - 1 do
     begin
       if i > 0 then
         Append(result, ',', Parser.LineEnd);
       Append(result, ['    ''', QueryParameters.Names[i], ''', ',
         VariantToUtf8(QueryParameters.Values[i])]);
     end;
     Append(result, Parser.LineEnd, '    ]');
   end
   // Either ActionArgs and QueryArgs or None of them (for Request parameters)
   else if (ActionArgs <> nil) or
           Assigned(fPayloadParameterType) then
     Append(result, ', []');

   // Payload if any
   if Assigned(fPayloadParameterType) then
   begin
     Append(result, ', Payload, ');
     if Assigned(fSuccessResponseType) then
       Append(result, 'Result, ')
     else
       Append(result, '{Not used, but need to send a pointer}self, ');

     Append(result, ['TypeInfo(', fPayloadParameterType.ToPascalName, '), ']);
     if Assigned(fSuccessResponseType) then
       Append(result, ['TypeInfo(', fSuccessResponseType.ToPascalName, ')'])
     else
       Append(result, 'nil');
   end
   // Response type if any
   else if Assigned(fSuccessResponseType) then
   begin
     Append(result, [', Result, TypeInfo(', fSuccessResponseType.ToPascalName, ')']);
   end;

  Append(result, [');', Parser.LineEnd, 'end;', Parser.LineEnd]);
end;

function TPascalOperation.FunctionName: RawUtf8;
begin
  result := fOperation^.Id;
  if result <> '' then
    result[1] := UpCase(result[1]); // as in regular Pascal
end;


{ TPascalProperty }

constructor TPascalProperty.Create(const aName: RawUtf8;
  aSchema: POpenApiSchema; aType: TPascalType);
begin
  fName := aName;
  fSchema := aSchema;
  fType := aType;
  fPascalName := SanitizePropertyName(fName);
end;

destructor TPascalProperty.Destroy;
begin
  fType.Free;
  inherited Destroy;
end;

constructor TPascalProperty.CreateFromSchema(aOwner: TOpenApiParser;
  const aName: RawUtf8; aSchema: POpenApiSchema; ParentField: boolean);
begin
  fType := TPascalType.LoadFromSchema(aOwner, aSchema);
  fType.fIsParent := ParentField;
  fName := aName;
  fSchema := aSchema;
  fPascalName := SanitizePropertyName(fName);
end;

function IsReservedKeyWord(const aName: RawUtf8): boolean;
begin
  result := FastFindPUtf8CharSorted(@RESERVED_KEYWORDS, high(RESERVED_KEYWORDS),
      pointer(LowerCaseU(aName))) >= 0;
end;

class function TPascalProperty.SanitizePropertyName(const aName: RawUtf8): RawUtf8;
begin
  CamelCase(aName, result);
  result[1] := UpCase(result[1]);
  if IsReservedKeyWord(result) then
    result := '_' + result;
end;


{ TPascalEnum }

constructor TPascalEnum.Create(aOwner: TOpenApiParser; const SchemaName: RawUtf8;
  aSchema: POpenApiSchema);
var
  i: PtrInt;
begin
  inherited Create(aOwner, 'T' + SchemaName);
  fName := SchemaName;
  fSchema := aSchema;
  fChoices.InitCopy(Variant(aSchema^.Enum^), JSON_FAST);
  fChoices.AddItem('None', 0);
  for i := 0 to length(SchemaName) - 1 do
    if SchemaName[i] in ['A' .. 'Z'] then
      Append(fPrefix, SchemaName[i]);
  LowerCaseSelf(fPrefix);
end;

function TPascalEnum.ToTypeDefinition(const LineIndentation: RawUtf8): RawUtf8;
var
  Choice: RawUtf8;
  i: PtrInt;
begin
  result := FormatUtf8('%% = (', [LineIndentation, PascalName]);
  for i := 0 to fChoices.Count - 1 do
  begin
    if i > 0 then
      Append(result,  ', ');
    Choice := StringReplaceAll(VariantToUtf8(fChoices.Values[i]), ' ', '');
    Choice[1] := UpCase(Choice[1]);
    Append(result, fPrefix, Choice);
  end;
  Append(result, [');', fParser.LineEnd, ToArrayTypeDefinition(LineIndentation)]);
end;

function TPascalEnum.ToArrayTypeName(AllowArrayType: boolean): RawUtf8;
begin
  if AllowArrayType then
    result := FormatUtf8('%Set', [PascalName])
  else
    result := FormatUtf8('set of %', [PascalName]);
end;

function TPascalEnum.ToConstTextArrayName: RawUtf8;
begin
  result := FormatUtf8('%_2TXT', [UpperCase(fName)]);
end;

function TPascalEnum.ToConstTextArray: RawUtf8;
var
  i: integer;
begin
  result := FormatUtf8('%: array[%] of RawUtf8 = (', [ToConstTextArrayName, PascalName]);
  for i := 0 to fChoices.Count - 1 do
    if i = 0 then
      Append(result, '''''') // first entry is for None/Default
    else
      Append(result, [', ''',
        StringReplaceAll(VariantToUtf8(fChoices.Values[i]), ' ', ''), '''']);
  Append(result, ');');
end;


{ TPascalType }

function TPascalType.IsBuiltin: boolean;
begin
  result := not Assigned(fCustomType);
end;

function TPascalType.GetSchema: POpenApiSchema;
begin
  if Assigned(CustomType) then
    result := CustomType.Schema
  else
    result := fBuiltinSchema;
end;

function TPascalType.IsEnum: boolean;
begin
  result := Assigned(fCustomType) and
            (fCustomType is TPascalEnum);
end;

function TPascalType.IsRecord: boolean;
begin
  result := Assigned(fCustomType) and
            (fCustomType is TPascalRecord);
end;

procedure TPascalType.SetArray(AValue: boolean);
begin
  fIsArray := AValue;
  if AValue and
     Assigned(CustomType) then
    CustomType.fRequiresArrayDefinition := true;
end;

constructor TPascalType.CreateBuiltin(const aBuiltinTypeName: RawUtf8;
  aSchema: POpenApiSchema; aIsArray: boolean);
begin
  fBuiltinTypeName := aBuiltinTypeName;
  fBuiltinSchema := aSchema;
  IsArray := aIsArray;
end;

constructor TPascalType.CreateCustom(aCustomType: TPascalCustomType;
  aIsArray: boolean; aIsParent: boolean);
begin
  fCustomType := aCustomType;
  IsArray := aIsArray;
  fIsParent := aIsParent;
end;

class function TPascalType.LoadFromSchema(Parser: TOpenApiParser;
  Schema: POpenApiSchema): TPascalType;
var
  Rec: TPascalRecord;
  fmt: RawUtf8;
  enumType: TPascalEnum;
begin
  if (Schema^.Reference <> '') or
     (Schema^.AllOf <> nil) then
  begin
    if Schema^.AllOf <> nil then
    begin
      if Schema^.AllOf^.Count <> 1 then
        EOpenApi.RaiseUtf8('%.LoadFromSchema with "allOf".Count=%',
          [self, Schema^.AllOf^.Count]);
      Rec := Parser.GetRecord(POpenApiSchema(@Schema^.AllOf^.Values[0])^.Reference, true);
    end
    else
      Rec := Parser.GetRecord(Schema^.Reference, true);
    result := TPascalType.CreateCustom(Rec);
  end
  else if Schema^.IsArray then
  begin
    // TODO: Handle array of arrays
    result := LoadFromSchema(Parser, Schema^.Items);
    result.fBuiltinSchema := Schema;
    result.IsArray := true;
  end
  else if Schema^.IsNamedEnum then
  begin
    fmt := Schema^._Format;
    enumType := Parser.fEnums.GetObjectFrom(fmt);
    if enumType = nil then
    begin
      enumType := TPascalEnum.Create(Parser, fmt, Schema);
      Parser.fEnums.AddObject(fmt, enumType);
    end;
    result := TPascalType.CreateCustom(enumType);
  end
  else
    result := TPascalType.CreateBuiltin(Schema.BuiltinType, Schema);
end;

function TPascalType.ToPascalName(AllowArrayType, NoRecordArrayTypes: boolean): RawUtf8;
var
  ok: boolean;
begin
  if Assigned(CustomType) then
    result := CustomType.PascalName
  else
    result := fBuiltinTypeName;
  if not AllowArrayType or
     (NoRecordArrayTypes and (result = 'TDocVariantData')) then
    result := 'variant';
  if IsArray then
  begin
    if Assigned(CustomType) then
    begin
      ok := AllowArrayType;
      if NoRecordArrayTypes and AllowArrayType and IsRecord then
        ok := false;
      result := CustomType.ToArrayTypeName(ok);
    end
    else
      result := FormatUtf8('array of %', [result]);
  end;
end;

function TPascalType.ToFormatUtf8Arg(const VarName: RawUtf8): RawUtf8;
begin
  if IsBuiltin and
     IdemPropNameU(fBuiltinTypeName, 'TGuid') then
    result := FormatUtf8('ToUtf8(%)', [VarName])
  else if IsEnum then
    result := FormatUtf8('%[%]',
      [(fCustomType as TPascalEnum).ToConstTextArrayName, VarName])
  else
    result := VarName;
end;

function TPascalType.ToDefaultParameterValue(aParam: POpenApiParameter): RawUtf8;
var
  DefaultValue: PVariant;
  t: RawUtf8;
begin
  DefaultValue := aParam^.Default;
  if Assigned(DefaultValue) then
  begin
    // explicit default value
    if VarIsEmptyOrNull(DefaultValue^) then
      if IsEnum then
        result := (CustomType as TPascalEnum).Prefix + 'None'
      else
        result := 'nil'
    else if PVarData(DefaultValue)^.VType = varBoolean then
      result := BOOL_UTF8[PVarData(DefaultValue)^.VBoolean]
    else if VariantToUtf8(DefaultValue^, result) then
      result := QuotedStr(result);
  end
  else
  begin
    // default from type
    t := aParam^.AsSchema^._Type;
    if t = 'string' then
      result := ''''''
    else if (t = 'number') or
            (t = 'integer') then
      result := '0'
    else if t = 'boolean' then
      result := 'false'
    else
      result := 'nil';
  end;
end;


{ TPascalRecord }

constructor TPascalRecord.Create(aOwner: TOpenApiParser;
  const SchemaName: RawUtf8; Schema: POpenApiSchema);
begin
  fName := SchemaName;
  fSchema := Schema;
  fProperties := TRawUtf8List.CreateEx([fObjectsOwned, fCaseSensitive, fNoDuplicate]);
  inherited Create(aOwner, 'T' + fName);
end;

destructor TPascalRecord.Destroy;
begin
  fProperties.Free;
  inherited Destroy;
end;

function TPascalRecord.ToTypeDefinition(const LineIndentation: RawUtf8): RawUtf8;
var
  i: PtrInt;
  p: TPascalProperty;
  s: POpenApiSchema;
begin
  result := LineIndentation;
  Append(result, [PascalName, ' = packed record', fParser.LineEnd]);
  for i := 0 to fProperties.Count - 1 do
  begin
    p := fProperties.ObjectPtr[i];
    s := p.fSchema;
    if Assigned(s) and
       (s^.Description <> '') then
      Append(result, [LineIndentation, '  /// ', s^.Description, fParser.LineEnd]);
    Append(result, [LineIndentation, '  ', p.fPascalName, ': ',
      p.fType.ToPascalName, ';', fParser.LineEnd]);
  end;
  Append(result, [LineIndentation, 'end;', fParser.LineEnd,
    ToArrayTypeDefinition(LineIndentation)]);
end;

function TPascalRecord.ToRttiTextRepresentation(WithClassName: boolean): RawUtf8;
var
  i: PtrInt;
  p: TPascalProperty;
begin
  if WithClassName then
    FormatUtf8('_% = ''', [PascalName], result)
  else
    result := '';
  for i := 0 to fProperties.Count - 1 do
  begin
    p := fProperties.ObjectPtr[i];
    // Only records can be parent types
    if p.fType.IsParent then
      Append(result, (p.fType.CustomType as TPascalRecord).ToRttiTextRepresentation(false))
    else
      Append(result, [fProperties[i], ': ', p.fType.ToPascalName(true, true), '; ']);
  end;
  if WithClassName then
    Append(result, ''';');
end;

function TPascalRecord.ToRttiRegisterDefinitions: RawUtf8;
begin
  result := FormatUtf8('TypeInfo(%), _%', [PascalName, PascalName]);
end;


{ TOpenApiParser }

constructor TOpenApiParser.Create;
begin
  fRecords := TRawUtf8List.CreateEx([fObjectsOwned, fCaseSensitive, fNoDuplicate]);
  fEnums := TRawUtf8List.CreateEx([fObjectsOwned, fCaseSensitive, fNoDuplicate]);
  fLineEnd := CRLF; // default to OS value
end;

destructor TOpenApiParser.Destroy;
begin
  fRecords.Free;
  fEnums.Free;
  ObjArrayClear(fOperations);
  inherited Destroy;
end;

procedure TOpenApiParser.Clear;
begin
  fRecords.Clear;
  fSpecs.Clear;
  ObjArrayClear(fOperations);
end;

function TOpenApiParser.Specs: POpenApiSpecs;
begin
  result := POpenApiSpecs(@fSpecs);
end;

function TOpenApiParser.Info: PDocVariantData;
begin
  result := fSpecs.O['info'];
end;

procedure TOpenApiParser.Parse(const aSpecs: TDocVariantData);
begin
  Clear;
  fSpecs.InitCopy(Variant(aSpecs), JSON_FAST);
  ParseSpecs;
end;

procedure TOpenApiParser.ParseJson(const aJson: RawUtf8);
begin
  Clear;
  fSpecs.InitJson(aJson, JSON_FAST);
  ParseSpecs;
end;

procedure TOpenApiParser.ParseFile(const aJsonFile: TFileName);
begin
  Clear;
  fSpecs.InitJsonFromFile(aJsonFile, JSON_FAST);
  ParseSpecs;
end;

procedure TOpenApiParser.ParseSpecs;
var
  v: PDocVariantData;
  i: PtrInt;
begin
  v := Specs^.Definitions;
  for i := 0 to v^.Count - 1 do
    if not fRecords.Exists(v^.Names[i]) then
      fRecords.AddObject(v^.Names[i], ParseDefinition(v^.Names[i]));
  v := Specs^.Paths;
  for i := 0 to v^.Count - 1 do
    ParsePath(v^.Names[i]);
end;

function TOpenApiParser.ParseDefinition(const aDefinitionName: RawUtf8): TPascalRecord;
var
  s: POpenApiSchema;
  n, i, j: PtrInt;
  def: array of POpenApiSchema;
  propname: RawUtf8;
  v: PDocVariantData;
begin
  s := Specs^.Definition[aDefinitionName];
  if not Assigned(s) then
    EOpenApi.RaiseUtf8('Cannot parse missing definition: %', [aDefinitionName]);
  if not s^.IsObject then
    EOpenApi.RaiseUtf8('% is not of type: object', [aDefinitionName]);

  result := TPascalRecord.Create(self, aDefinitionName, s);
  // fill def[] with all needed schemas
  v := s^.AllOf;
  if v <> nil then
  begin
    SetLength(def, v^.Count);
    for i := 0 to v^.Count - 1 do
      def[i] := @v^.Values[i];
  end
  else
  begin
    SetLength(def, 1);
    def[0] := s;
  end;
  // append all fields to result.Properties
  n := 0;
  for i := 0 to high(def) do
  begin
    s := def[i];
    // append $ref as 'base###:' nested field
    if s^.Reference <> '' then
    begin
      if n = 0 then
        propname := 'base'
      else
        propname := FormatUtf8('base_%', [n]); // avoid duplicates
      inc(n);
      result.fProperties.AddObject(propname,
        TPascalProperty.CreateFromSchema(self, propname, s, {parent=}true));
    end;
    // append specific fields
    v := s^.Properties;
    if v <> nil then
      for j := 0 to v^.Count - 1 do
        result.fProperties.AddObject(v^.Names[j],
          TPascalProperty.CreateFromSchema(self, v^.Names[j], @v^.Values[j]));
  end;
end;

procedure TOpenApiParser.ParsePath(const aPath: RawUtf8);
var
  m: TUriMethod;
  p: POpenApiPathItem;
  s: POpenApiOperation;
  op: TPascalOperation;
begin
  p := Specs^.Path[aPath];
  for m := low(m) to high(m) do
  begin
    s := p^.Method[m];
    if not Assigned(s) or
       s^.Deprecated then
      continue;
    op := TPascalOperation.Create(aPath, p, s, m);
    op.ResolveTypes(self);
    ObjArrayAdd(fOperations, op);
  end;
end;

function TOpenApiParser.GetRecord(aRecordName: RawUtf8;
  NameIsReference: boolean): TPascalRecord;
begin
  if NameIsReference then
    // #/definitions/NewPet -> NewPet
    aRecordName := SplitRight(aRecordName, '/');
  result := fRecords.GetObjectFrom(aRecordName);
  if result <> nil then
    exit;
  result := ParseDefinition(aRecordName);
  fRecords.AddObject(aRecordName, result);
end;

function HasDependencies(const Sources: TPascalRecordDynArray;
  const Searched: TRawUtf8DynArray): boolean;
var
  found: boolean;
  name: RawUtf8;
  i, j: PtrInt;
begin
  result := false;
  for i := 0 to high(Searched) do
  begin
    name := Searched[i];
    found := false;
    for j := 0 to high(Sources) do
      if Sources[j].Name = name then
      begin
        found := true;
        break;
      end;
    if not found then
      exit;
  end;
  result := true;
end;

function TOpenApiParser.GetOrderedRecords: TPascalRecordDynArray;
var
  pending, missing: TPascalRecordDynArray;
  r: TPascalRecord;
  i: PtrInt;
begin
  result := nil;
  // direct resolution
  for i := 0 to fRecords.Count - 1 do
  begin
    r := fRecords.ObjectPtr[i];
    if not Assigned(r.fDependencies) or
           HasDependencies(result, r.fDependencies) then
      ObjArrayAdd(result, r)
    else
      ObjArrayAdd(pending, r);
  end;
  // nested resolution
  while pending <> nil do
  begin
    missing := nil;
    for i := 0 to high(pending) do
      if HasDependencies(result, pending[i].fDependencies) then
        ObjArrayAdd(result, pending[i])
      else
        ObjArrayAdd(missing, pending[i]);
    pending := missing;
  end;
end;

function TOpenApiParser.GetOperationsByTag: TPascalOperationsByTagDynArray;
var
  main: PDocVariantData;
  tag: TRawUtf8DynArray;
  i, j, k, count, ndx: PtrInt;
begin
  result := nil;
  if fOperations = nil then
    exit;
  // regroup operations per tags, eventually with result[0].Tag=nil
  count := 1;
  SetLength(result, length(fOperations) + 1);
  main := Specs^.Tags;
  for i := 0 to length(fOperations) - 1 do
  begin
    tag := fOperations[i].fOperation^.Tags;
    if tag <> nil then
    begin
      // add to all tags by name in result[1..]
      for j := 0 to high(tag) do
      begin
        ndx := -1;
        for k := 1 to count - 1 do
          if result[k].TagName = tag[j] then
          begin
            ndx := k;
            break;
          end;
        if ndx < 0 then
        begin
          ndx := count;
          inc(count);
          result[ndx].TagName := tag[j];
          main.GetAsObject(tag[j], PDocVariantData(result[ndx].Tag)); // maybe nil
        end;
        ObjArrayAdd(result[ndx].Operations, fOperations[i]);
      end;
    end
    else
      // if not tag involved, just append in result[0]
      ObjArrayAdd(result[0].Operations, fOperations[i]);
  end;
  SetLength(result, count);
  // caller will ensure a single fOperations[] method will be generated
end;

procedure TOpenApiParser.Dump;
var
  rec: TPascalRecordDynArray;
  i: PtrInt;
begin
  rec := GetOrderedRecords;
  for i := 0 to high(rec) do
    ConsoleWrite(rec[i].ToTypeDefinition);
end;

function GetDescription(Info: PDocVariantData;
  const UnitDescription, LineEnd: RawUtf8): RawUtf8;
var
  u: RawUtf8;
  v: variant;
begin
  result := '';
  if Info = nil then
    exit;
  result := FormatUtf8('/// % %%', [UnitDescription, Info^.U['title'], LineEnd]);
  if Info^.GetAsRawUtf8('description', u) then
    Append(result, ['// - ', u, LineEnd]);
  if Info^.GetAsRawUtf8('version', u) then
    Append(result, ['// - version ', u, LineEnd]);
  if Info^.GetValueByPath('license.name', v) then
    Append(result, ['// - OpenAPI definition licensed under ', v, ' terms', LineEnd]);
end;

function TOpenApiParser.GetDtosUnit(const UnitName: RawUtf8): RawUtf8;
var
  rec: TPascalRecordDynArray;
  enum: TPascalEnum;
  i: PtrInt;
begin
  result := '';
  // unit common definitions
  Append(result, [
    GetDescription(Info, 'DTOs for', LineEnd),
    'unit ', UnitName, ';', LineEnd , LineEnd,
    '{$I mormot.defines.inc}', LineEnd ,
    LineEnd,
    'interface', LineEnd,
    LineEnd,
    'uses', LineEnd,
    '  classes,', LineEnd,
    '  sysutils,', LineEnd,
    '  mormot.core.base,', LineEnd,
    '  mormot.core.rtti,', LineEnd,
    '  mormot.core.variants;', LineEnd,
    LineEnd,
    'type', LineEnd, LineEnd]);
  // append all enumeration types
  if fEnums.Count > 0 then
  begin
    for i := 0 to fEnums.Count - 1 do
      Append(result, TPascalEnum(fEnums.ObjectPtr[i]).ToTypeDefinition('  '));
    Append(result, LineEnd, LineEnd);
  end;
  // append all records
  rec := GetOrderedRecords;
  for i := 0 to high(rec) do
    Append(result, rec[i].ToTypeDefinition('  '), LineEnd);
  // enumeration-to-text constants
  if fEnums.Count > 0 then
  begin
    Append(result, [LineEnd, LineEnd, 'const', LineEnd, LineEnd]);
    for i := 0 to fEnums.Count - 1 do
      Append(result, ['  ', TPascalEnum(fEnums.ObjectPtr[i]).ToConstTextArray, LineEnd]);
  end;
  // start implementation section
  Append(result, [LineEnd, LineEnd,
    'implementation', LineEnd, LineEnd]);
  // output the text representation of all records
  // with proper json names (overriding the RTTI definitions)
  if rec <> nil then
  begin
    Append(result, ['const', LineEnd]);
    for i := 0 to high(rec) do
      Append(result, ['  ', rec[i].ToRttiTextRepresentation, LineEnd]);
  end;
  // define the RTTI registratoin procedure
  Append(result, [LineEnd, LineEnd,
    'procedure RegisterRtti;', LineEnd,
    'begin', LineEnd]);
  // register all needed enum types RTTI
  if fEnums.Count > 0 then
  begin
    Append(result, '  Rtti.RegisterTypes([', LineEnd);
    for i := 0 to fEnums.Count - 1 do
    begin
      if i <> 0 then
        Append(result, ',', LineEnd);
      enum := fEnums.ObjectPtr[i];
      Append(result, ['    TypeInfo(', enum.PascalName, ')']);
      if enum.fRequiresArrayDefinition then
        Append(result, [',', LineEnd, '    TypeInfo(', enum.ToArrayTypeName, ')']);
    end;
    Append(result, [LineEnd, '  ]);', LineEnd]);
  end;
  // register all record types RTTI
  if rec <> nil then
  begin
    Append(result, ['  Rtti.RegisterFromText([', LineEnd]);

    for i := 0 to high(rec) do
    begin
      if i > 0 then
        Append(result, ',', LineEnd);
      Append(result, '    ', rec[i].ToRttiRegisterDefinitions);
    end;
    Append(result, [']);', LineEnd,
      'end;', LineEnd, LineEnd]);
  end;
  // finish the unit
  Append(result, [
    'initialization', LineEnd,
    '  RegisterRtti;', LineEnd,
    LineEnd,
    'end.', LineEnd]);
end;

function TOpenApiParser.GetClientUnit(
  const UnitName, ClientClassName, DtoUnitName: RawUtf8): RawUtf8;
var
  bytag: TPascalOperationsByTagDynArray;
  done: TRawUtf8DynArray;
  ops: TPascalOperationsByTag;
  op: TPascalOperation;
  id, desc, u: RawUtf8;
  bannerlen, i, j: PtrInt;
begin
  result := '';
  // unit common definitions
  Append(result, [
    GetDescription(Info, 'Client unit for', LineEnd),
    'unit ', UnitName, ';', LineEnd,
    LineEnd,
    '{$mode ObjFPC}{$H+}', LineEnd,
    LineEnd,
    'interface', LineEnd,
    LineEnd,
    'uses', LineEnd,
    '  classes,', LineEnd,
    '  sysutils,', LineEnd,
    '  mormot.core.base,', LineEnd,
    '  mormot.core.text,', LineEnd,
    '  mormot.core.rtti,', LineEnd,
    '  mormot.core.variants,', LineEnd,
    '  mormot.net.client,', LineEnd,
    '  ', DtoUnitName, ';', LineEnd,
    LineEnd,
    'type',
    LineEnd,
    '  ', ClientClassName, ' = class', LineEnd,
    '  private', LineEnd,
    '    fClient: IJsonClient;', LineEnd,
    '  public', LineEnd,
    '    // initialize with an associated HTTP/JSON request', LineEnd,
    '    constructor Create(const aClient: IJsonClient = nil);', LineEnd]);
  // append all methods, regrouped per tag (if any)
  bytag := GetOperationsByTag;
  for i := 0 to high(bytag) do
  begin
    ops := bytag[i];
    if ops.Operations = nil then
      continue; // nothing to add (e.g. i=0)
    bannerlen := 0;
    for j := 0 to high(ops.Operations) do
    begin
      op := ops.Operations[j];
      id := op.fOperation^.Id;
      if FindRawUtf8(done, id) >= 0 then
        // Operations can be in multiple tags but can't be defined multiple times in same class
        continue;
      AddRawUtf8(done, id);
      if (bannerlen = 0) and
         (ops.TagName <> '') then // regrouped by tag, if any
      begin
        desc := ops.Tag^.Description;
        bannerlen := 18 + Length(ops.TagName) + Length(desc);
        u := RawUtf8OfChar('/', bannerlen);
        Append(result, [LineEnd, LineEnd,
          '    ////', u, LineEnd,
          '    //// ---- ', ops.TagName, ': ', desc, ' ---- ////', LineEnd,
          '    ////', u, LineEnd, LineEnd]);
      end;
      Append(result, op.Documentation(LineEnd, '    '));
      // We send an empty classname because this is the declaration, we want format:
      // function fctName(fctParams): Result;
      // Not
      // function TClassName.fctName(fctParams): Result;
      Append(result, ['    ', op.Declaration('', self), LineEnd]);
    end;
  end;
  // finalize the class definition and start the implementation section
  Append(result, [LineEnd,
    '    // access to the associated HTTP/JSON request', LineEnd,
    '    property JsonClient: IJsonClient', LineEnd,
    '      read fClient write fClient;', LineEnd,
    '  end;', LineEnd,
    LineEnd,
    'implementation', LineEnd, LineEnd, LineEnd,
    '{ ', ClientClassName, '}', LineEnd, LineEnd,
    'constructor ', ClientClassName, '.Create(const aClient: IJsonClient);', LineEnd,
    'begin', LineEnd,
    '  fClient := aClient;', LineEnd,
    'end;', LineEnd, LineEnd]);
  // append all methods, in native order (no need to follow tag ordering)
  for i := 0 to high(Operations) do
    Append(result, Operations[i].Body(ClientClassName, Specs^.BasePath, self), LineEnd);
  Append(result, LineEnd, 'end.');
end;

procedure TOpenApiParser.ExportToDirectory(Name: RawUtf8;
  DirectoryName: RawUtf8; UnitPrefix: RawUtf8);
var
  dtounit, clientunit: RawUtf8;
  dtofn, clientfn: TFileName;
begin
  dtounit := FormatUtf8('%%Dtos', [UnitPrefix, Name]);
  dtofn := MakePath([DirectoryName, dtounit + '.pas']);
  clientunit := FormatUtf8('%%Client', [UnitPrefix, Name]);
  clientfn := MakePath([DirectoryName, clientunit + '.pas']);
  FileFromString(GetDtosUnit(dtounit), dtofn);
  FileFromString(GetClientUnit(clientunit, FormatUtf8('T%Client', [Name]), dtounit), clientfn);
end;


end.

