export interface BoqDescListRes {
  BoqItems: BoqItems[];
}
export interface BoqItems {
  location: string;
  mainitem: string;
  subitem: string;
  subsubitem: string;
  boqref: string;
  boqtask: string;
  unit: string;
  qty: number;
  rate: number;
  cost: number;
  workdone: number;
  startdate: string;
  enddate: string;
  dep: string;
}
