import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { SubItemMaster } from './sub-item';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';
import { MainItemMaster } from '../main-item/main-item';

@Component({
  selector: 'app-sub-item',
  templateUrl: './sub-item.component.html',
  styleUrls: ['./sub-item.component.scss']
})
export class SubItemComponent implements OnInit {
  mainItemList: MainItemMaster[];
  subItemList: SubItemMaster[];
  modalTitle: string;
  isAdd: boolean;
  subItemForm: FormGroup;
  sampleText: NguModal;

  displayedColumns = [
    'MainItemName',
    'SubItemName',
    'SubItemDescription',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.subItemList);
  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getsubItem();

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  private getsubItem() {
    this.ms.getSubItem().subscribe(res => {
      console.log(res);
      this.subItemList = res;
      this.dataSource.data = this.subItemList;
    });
  }
  getmainItem() {
    this.ms.getMainItem().subscribe(res => {
      this.mainItemList = res;
    });
  }
  createForm() {
    this.subItemForm = this.fb.group({
      SubItemId: '',
      MainItemId: ['', Validators.required],
      SubItemName: ['', Validators.required],
      SubItemDescription: '',
      Status: ['', Validators.required]
    });
  }

  subItemSubmit() {
    console.log(this.subItemForm.value);
    if (this.isAdd) {
      this.ms.addSubItem(this.subItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsubItem();
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
      this.ms.updateSubItem(this.subItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getsubItem();
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

  editsubItem(row) {
    this.modalTitle = 'Edit Sub Item';
    this.isAdd = false;
    console.log(row);
    this.getmainItem();
    this.subItemForm.patchValue({
      MainItemId: row.MainItemId,
      SubItemId: row.SubItemId,
      SubItemName: row.SubItemName,
      SubItemDescription: row.SubItemDescription,
      Status: row.Status
    });
    this.modal.open(this.sampleText.id);
  }

  addsubItem() {
    this.modalTitle = 'Add Sub Item';
    this.isAdd = true;
    this.getsubItem();
    this.getmainItem();
    this.subItemForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
