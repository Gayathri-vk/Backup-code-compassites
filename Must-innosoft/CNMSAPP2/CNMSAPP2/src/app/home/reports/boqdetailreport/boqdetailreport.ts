export interface BOQDetail {
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
  Workdonedate: String;
  start_date: string;
  end_date: string;
  duration: number;
  dep: string;
  wcost: number;
}
