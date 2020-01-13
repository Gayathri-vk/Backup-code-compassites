export interface BOQTASKUPP {
  bOQTASK: BOQTASK[];
}

export interface BOQPRO {
  BOQId: number;
  name: string;
  MainItem: string;
  SubItem: string;
  SubSubItem: string;
  Task: string;
  WorkdonePer: string;
  CompletedPer: number;
  Date: string;
}
export interface BOQDATA {
  BOQId: number;
  SubSubItem: string;
}
export interface BOQTASK {
  BOQId: number;
  MainItemId: number;
  MainItem: string;
  SubItem: string;
  SubSubItem: string;
  CompletedPer: number;
  WorkdonePer: number;
  WorkdoneType: string;
}

export interface BOQTASKRes {
  status: boolean;
  message: string;
}

export interface BOQMainItem {
  MainItemId: number;
  MainItem: string;
}
export interface BOQSubItem {
  SubItemId: number;
  SubItem: string;
}
export interface BOQSubSubItem {
  BOQID: number;
  SubSubItem: string;
}
export interface BOQWorkPer {
  CompletedPer: string;
}
