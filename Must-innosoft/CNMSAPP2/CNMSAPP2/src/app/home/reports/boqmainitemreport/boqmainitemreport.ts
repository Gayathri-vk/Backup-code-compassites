export interface BOQMainDetail {
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
  qty: String;
  urate: String;
  tcost: String;
  progress: String;
  Workdonedate: String;
  start_date: string;
  end_date: string;
  duration: String;
  dep: string;
  wcost: number;
}
