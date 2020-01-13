export interface BOQREV {
  BOQId: number;
  name: string;
  MainItem: string;
  SubItem: string;
  SubSubItem: string;
  Task: string;
  WorkdonePer: string;
  start_date: string;
  end_date: string;
  revice_start_date: string;
  revice_end_date: string;
  ftype: string;
}
export interface BOQREVRes {
  status: boolean;
  message: string;
}
