export interface UserDetails {
  UserId: number;
  CompanyId: number;
  ClientId: number;
  CompanyName: string;
  ClientName: string;
  ClientCode: string;
  Username: string;
  Password: string;
  Loginuser: string;
  Designation: string;
  User_Role_Id: number;
  MaintanceDate: string;
  ExprieDate: string;
  Status: number;
  Type: string;
  SupplierId: number;
}

export interface UserDetailsRes {
  status: boolean;
  message: string;
}

export interface UserRoleRes {
  User_RoleId: number;
  Role_Name: string;
}
