export interface HolidayMaster {
  ClientId: number;
  HId: number;
  HolidayName: string;
  HolidayDate: string;
  ClientName: string;
  Status: number;
}

export interface HolidayMasterRes {
  status: boolean;
  message: string;
}
