export class Task {
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
  progress: number;
  parent: number;
  start_date: string;
  end_date: string;
  duration: number;
  dep: string;
  boqrefId: string;
  Workdonedate: String;
  wcost: number;
  type: string;
  RStartDate: string;
  REndDate: string;
  Criticaltaskid?: string;
  Predec: string;
  HDuration: number;
  ReviseType: string;
}
export class Link {
  id: number;
  source: number;
  target: number;
  type: string;
}
export enum GanttStep {
  project = 1,
  location,
  subItem,
  subSubItem
}
export interface HolidayRes {
  HolidayDate: any;
}
