export interface BoqdetailsList {
  ProjectId: string;
  ProjectDescription: string;
  BOQDescriptions: BOQDescription[];
}
// export interface BoqMaster {
//   location: string;
//   mainitem: string;
//   subitem: string;
//   subsubitem: string;
//   start_date: string;
//   end_date: string;
// }
export interface BOQDescription {
  Main: string;
  Sub: string;
  SubSub: string;
  Task: string;
  Date: string;
  Per: number;
}

export interface SubItemMasterDetails {
  SubItemName: string;
  SubItemId: number;
}

export class Link {
  id: number;
  source: number;
  target: number;
  type: string;
}

export class TaskV {
  ProjectId: string;
  id?: string;
  text: string;
  locationId: string;
  name: string;
  mainItemId: string;
  subitem: string;
  subsubitem: string;
  boq: string;
  task: string;
  unit: string;
  qty: number;
  urate: number;
  tcost: number;
  parent: number;
  start_date: string;
  end_date: string;
  duration: number;
  progress: number;
  dep: string;
  add?: any;
  step: GanttStep;
  boqrefId: string;
  flag: string;
  Predec: string;
  Priority: number;
  Slack: string;
  Criticaltaskid: string;
  RStartDate: string;
  REndDate: string;
  RDuration: number;
  HDuration: number;
  ReviseType: string;
}

export enum GanttStep {
  project = 1,
  location,
  subItem,
  subSubItem
}
export interface BoqResV {
  status: boolean;
  message: string;
}
