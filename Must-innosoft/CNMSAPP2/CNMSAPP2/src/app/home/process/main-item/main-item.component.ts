import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { MainItemMaster } from './main-item';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';

@Component({
  selector: 'app-main-item',
  templateUrl: './main-item.component.html',
  styleUrls: ['./main-item.component.scss']
})
export class MainItemComponent implements OnInit {
  mainItemList: MainItemMaster[];
  modalTitle: string;
  isAdd: boolean;
  mainItemForm: FormGroup;
  sampleText: NguModal;

  displayedColumns = ['MainItemName', 'MainItemDescription', 'Action'];
  dataSource = new MatTableDataSource(this.mainItemList);
  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getmainItem();

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  private getmainItem() {
    this.ms.getMainItem().subscribe(res => {
      console.log(res);
      this.mainItemList = res;
      this.dataSource.data = this.mainItemList;
    });
  }

  createForm() {
    this.mainItemForm = this.fb.group({
      MainItemId: '',
      MainItemName: ['', Validators.required],
      MainItemDescription: '',
      Status: ['', Validators.required]
    });
  }

  mainItemSubmit() {
    console.log(this.mainItemForm.value);
    if (this.isAdd) {
      this.ms.addMainItem(this.mainItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getmainItem();
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
      this.ms.updateMainItem(this.mainItemForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getmainItem();
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

  editmainItem(row) {
    this.modalTitle = 'Edit Main Item';
    this.isAdd = false;
    console.log(row);

    this.mainItemForm.patchValue({
      MainItemId: row.MainItemId,
      MainItemName: row.MainItemName,
      MainItemDescription: row.MainItemDescription,
      Status: row.Status
    });
    this.modal.open(this.sampleText.id);
  }

  addmainItem() {
    this.modalTitle = 'Add Main Item';
    this.isAdd = true;
    this.getmainItem();
    this.mainItemForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
