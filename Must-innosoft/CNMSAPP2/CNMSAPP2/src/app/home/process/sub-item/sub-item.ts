export interface SubItemMaster {
  MainItemId: number;
  MainItemName: string;
  SubItemId: number;
  SubItemName: string;
  SubItemDescription: string;
  Status: number;
}

export interface SubItemMasterRes {
  status: boolean;
  message: string;
}
