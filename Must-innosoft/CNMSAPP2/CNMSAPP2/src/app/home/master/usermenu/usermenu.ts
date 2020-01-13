export interface UserRoleMenu {
  UID: number;
  CompanyId: number;
  ClientId: number;
  CompanyName: string;
  ClientName: string;
  User_RoleId: number;
  MID: MIDList[];
  Status: number;
}
export interface MIDList {
  MID: any;
}
export interface UserRoleMenuRes {
  status: boolean;
  message: string;
}

export interface MenuDetailsRes {
  MID: number;
  Formname: string;
}
