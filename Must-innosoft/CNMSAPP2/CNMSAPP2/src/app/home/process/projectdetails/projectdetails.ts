export interface ProjectMaster {
  ClientId: number;
  ProjectId: number;
  ProjectName: string;
  ProjectLocation: string;
  ClientName: string;
  ProjectIncharge?: any;
  EmailId?: any;
  ContactNo?: any;
  UserId: number;
  End_Date: string;
  Start_Date: string;
  Status: number;
  Fromday: number;
  Today: number;
  Fromtime: number;
  Totime: number;
}

export interface ProjectMasterRes {
  status: boolean;
  message: string;
}

export interface ClientProjectRes {
  ClientId: number;
  ClientName: string;
}
