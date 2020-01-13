export interface Client {
  ClientId: number;
  CompanyId: number;
  CompanyName: string;
  ClientCode: string;
  ClientName: string;
  TaxNo?: any;
  GSTNo?: any;
  ContactPerson?: any;
  Designation?: any;
  HandPhoneNo?: any;
  TelePhoneNo?: any;
  EmailId?: any;
  Website?: any;
  UintNo?: any;
  Building?: any;
  Street?: any;
  City?: any;
  State?: any;
  StateCode?: any;
  Pincode?: any;
  CountryId: number;
  NoofUser: number;
  Remark?: any;
  ExprieDate: string;
  Status: number;
  CreatedUser: number;
}

export interface ClientRes {
  status: boolean;
  message: string;
}
