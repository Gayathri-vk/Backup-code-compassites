export interface DatabaseDetails {
  CompanyId: number;
  DatabaseId: number;
  ClientId: number;

  CompanyName: string;
  ClientName: string;

  Server_Name: string;
  DB_Name: string;
  DB_Username: string;
  DB_Password: string;
  Status: number;


}

export interface DatabaseRes {
  status: boolean;
  message: string;
}
