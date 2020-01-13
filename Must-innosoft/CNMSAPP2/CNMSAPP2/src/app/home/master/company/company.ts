export interface Company {
  CompanyId: number;
  CompanyName: string;
  UintNo: string;
  Building: string;
  Street?: any;
  City?: any;
  State?: any;
  StateCode?: any;
  Pincode?: any;
  Country?: any;
  TaxNo?: any;
  GSTNo?: any;
  AuthorisedPerson?: any;
  HandPhoneNo?: any;
  TelePhoneNo?: any;
  EmailId?: any;
  Website?: any;
  Clients: any[];
  DatabaseDetails: any[];
  UserDetails: any[];
}

export interface CompanyRes {
  status: boolean;
  message: string;
}
