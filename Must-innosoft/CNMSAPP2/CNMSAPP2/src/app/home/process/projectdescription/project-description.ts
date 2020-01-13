export interface ProjectDescriptionList {
  ProjectId: string;
  ProjectDescription: ProjectDescription;
  nameList: NameList[];
  ExternalWorks: ExternalWork[];
  MainItems: MainItem[];
}

export interface ExternalWork {
  externalId: string;
  externalName: string;
  uom: string;
  qty: number;
}

export interface NameList {
  name: string;
  list: List[];
}

export interface List {
  name: string;
  Floor: Foundation;
  LowerRoof: Foundation;
  UpperRoof: Foundation;
}

export interface ProjectDescription {
  Foundation: Foundation;
  Basement: Foundation;
  Podium: Foundation;
  Mezanine: Foundation;
}

export interface Foundation {
  status: number;
  qty: number;
  FoundationDes: FoundationDes[];
}

export interface FoundationDes {
  name: string;
}

export interface ExternalWorkMasterRes {
  ExId: number;
  ExternalWork: string;
  altTags: any[];
}

export interface ProjectDescriptionRes {
  status: boolean;
  message: string;
}
export interface MainItem {
  mainitem: string;
  cost: number;
}
