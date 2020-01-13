import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { HolidayMaster } from './holidayentry';
import { Client } from '../client/client';
import { NguModal, NguModalService } from '@ngu/modal';
import { MatTableDataSource } from '@angular/material';
import { MasterService } from '../master.service';
import { NguAlertService } from '@ngu/alert';

@Component({
  selector: 'app-holidayentry',
  templateUrl: './holidayentry.component.html',
  styleUrls: ['./holidayentry.component.scss']
})
export class HolidayentryComponent implements OnInit {
  modalTitle: string;
  holidayForm: FormGroup;

  HolidayList: HolidayMaster[];
  isAdd: boolean;
  clientList: Client[];
  sampleText: NguModal;
  displayedColumns = ['ClientName', 'HolidayName', 'HolidayDate', 'Action'];
  dataSource = new MatTableDataSource(this.HolidayList);
  constructor(
    private ms: MasterService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getholiday();
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  getholiday() {
    this.ms.getHoliday().subscribe(res => {
      console.log(res);
      this.HolidayList = res;
      this.dataSource.data = this.HolidayList;
    });
  }
  getClient(id) {
    this.ms.getClientLite(id).subscribe(res => {
      console.log(res);
      this.clientList = res;
    });
  }
  createForm() {
    this.holidayForm = this.fb.group({
      ClientId: ['', Validators.required],

      HId: '',
      HolidayName: ['', Validators.required],
      HolidayDate: ['', Validators.required],

      Status: ['', Validators.required]
    });
  }

  userSubmit() {
    console.log(this.holidayForm.value);
    if (this.isAdd) {
      this.ms.addHoliday(this.holidayForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getholiday();
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
      this.ms.updateHoliday(this.holidayForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getholiday();
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

  editUser(row) {
    this.modalTitle = 'Edit Holiday';
    this.isAdd = false;
    console.log(row);

    this.getClient(1);
    this.holidayForm.patchValue({
      HId: row.HId,
      ClientId: row.ClientId,

      HolidayName: row.HolidayName,
      HolidayDate: row.HolidayDate,

      Status: row.Status
    });

    this.modal.open(this.sampleText.id);
  }

  addUser() {
    this.modalTitle = 'Add Holiday';
    this.isAdd = true;
    this.getClient(1);
    this.getholiday();
    this.holidayForm.reset();

    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
