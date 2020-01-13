export interface Supplier {
  SupplierId: number;
  ClientId: number;
  CompanyId: number;
  CompanyName: string;
  Type: string;
  ClientName: string;
  SupplierName: string;
  SupplierAddress?: any;
  ContactPerson?: any;
  ContactNo?: any;
  EmailId?: any;
  Status: number;
}
export interface SupplierRes {
  status: boolean;
  message: string;
}
