import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { SubSubItemMaster } from './sub-sub-item';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';
import { MainItemMaster } from '../main-item/main-item';
import { SubItemMaster } from '../sub-item/sub-item';
@Component({
  selector: 'app-sub-sub-item',
  templateUrl: './sub-sub-item.component.html',
  styleUrls: ['./sub-sub-item.component.scss']
})
export class SubSubItemComponent implements OnInit {
  mainItemList: MainItemMaster[];
  subItemList: SubItemMaster[];
  subsubItemList: SubSubItemMaster[];
  modalTitle: string;
  isAdd: boolean;
  subsubItemForm: FormGroup;
  sampleText: NguModal;

  displayedColumns = [
    'MainItemName',
    'SubItemName',
    'SubSubItemName',
    'SubSubItemDescription',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.subsubItemList);
  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getsubsubItem();

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  private getsubsubItem() {
    this.ms.getSubSubItem().subscribe(res => {
      console.log(res);
      this.subsubItemList = res;
      this.dataSource.data = this.subsubItemList;
    });
  }
  getmainItem() {
    this.ms.getMainItem().subscribe(res => {
      this.mainItemList = res;
    });
  }
  getsubItem(id) {
    this.ms.getSubItemLite(id).subscribe(res => {
      console.log(res);
      this.subItemList = res;
    });
  }
  createForm() {
    this.subsubItemForm = this.fb.group({
      SubSubItemId: '',
      SubItemId: ['', Validators.required],
      MainItemId: ['', Validators.required],
      SubSubItemName: ['', Validators.required],
      SubSubItemDescription: '',
      Status: ['', Validators.required]
    });
    this.subsubItemForm.get('MainItemId').valueChanges.subscribe(res => {
      this.getsubItem(res);
    });
  }

  subsubItemSubmit() {
    console.log(this.subsubItemForm.value);
    if (this.isAdd) {
      this.ms.addSubSubItem(this.subsubItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsubsubItem();
        } else {
          this.alert.open({
            heading: 'Saving Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
    } else {
      this.ms.updateSubSubItem(this.subsubItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsubsubItem();
        } else {
          this.alert.open({
            heading: 'Update Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
    }
  }

  openModal() {
    this.modal.open(this.sampleText.id);
  }

  closeModal() {
    this.modal.close(this.sampleText.id);
  }

  editsubsubItem(row) {
    this.modalTitle = 'Edit Sub Item';
    this.isAdd = false;
    console.log(row);
    this.getmainItem();
    this.getsubItem(row.MainItemId);
    this.subsubItemForm.patchValue({
      MainItemId: row.MainItemId,
      SubItemId: row.SubItemId,
      SubSubItemId: row.SubSubItemId,
      SubSubItemName: row.SubSubItemName,
      SubSubItemDescription: row.SubSubItemDescription,
      Status: row.Status
    });
    this.modal.open(this.sampleText.id);
  }

  addsubsubItem() {
    this.modalTitle = 'Add Sub Item';
    this.isAdd = true;
    this.getsubsubItem();
    this.getmainItem();
    this.subsubItemForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
