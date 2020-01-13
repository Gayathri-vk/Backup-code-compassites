export interface SubSubItemMaster {
  MainItemId: number;
  MainItemName: string;
  SubItemId: number;
  SubItemName: string;
  SubSubItemId: number;
  SubSubItemName: string;
  SubSubItemDescription: string;
  Status: number;
}

export interface SubSubItemMasterRes {
  status: boolean;
  message: string;
}
