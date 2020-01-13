import { Component, OnInit } from '@angular/core';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';
import {
  BOQTASK,
  BOQPRO,
  BOQTASKRes,
  BOQTASKUPP,
  BOQDATA,
  BOQMainItem,
  BOQSubItem,
  BOQSubSubItem,
  BOQWorkPer
} from './boqprocess';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators, FormArray } from '@angular/forms';
import { MatTableDataSource } from '@angular/material';

@Component({
  selector: 'app-boqprocess',
  templateUrl: './boqprocess.component.html',
  styleUrls: ['./boqprocess.component.scss']
})
export class BoqprocessComponent implements OnInit {
  boqFutureForm: FormGroup;
  boqprocessForm: FormGroup;
  modalTitle: string;
  boqmainlist: BOQMainItem[];
  boqsublist: { [x: string]: BOQSubItem[] } = {};
  boqsubsublist: { [x: string]: BOQSubSubItem[] } = {};
  boqsWokperlist: { [x: string]: BOQWorkPer[] } = {};
  boqtasklist: BOQTASKUPP;
  boqvarlist: BOQTASKUPP;
  boqtask: BOQTASK[] = [];
  boqprolist: BOQPRO[];
  boqdatalist: BOQDATA[];
  Boqwper: BOQWorkPer[];
  sampleText: NguModal;
  cudate = new Date();
  dd = this.cudate.getDate();
  mm = this.cudate.getMonth() + 1; // January is 0!
  yyyy = this.cudate.getFullYear();
  today = this.dd + '/' + this.mm + '/' + this.yyyy;
  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '1200px', lg: '1200px' }
    };
    this.getboqpro(0);
    this.getboqMainItem();
    this.createForm();
    this.getboqData(1);
    this.getvarData(2);
    // this.addsubItem();
  }

  onChange(index) {
    const data = this.boqItemArray.at(index);
    const value = data.get('MainItem').value;
    this.getboqSubItem(value, 2);
    data.patchValue({
      SubItem: '',
      SubSubItem: ''
    });
  }
  onChange1(index) {
    const data = this.boqItemArray.at(index);
    const value = data.get('MainItem').value;
    this.getboqSubSubItem(value, 1);
    data.patchValue({
      SubSubItem: ''
    });
  }
  onChange2(index) {
    const data = this.boqItemArray.at(index);
    const value = data.get('BOQId').value;
    this.getboqWorkPer(value, 3);
  }
  getboqSubItem(id, val) {
    this.ms.getBoqSubItem(id, val).subscribe(res => {
      console.log(res);
      this.boqsublist[id] = res;
    });
  }
  getboqSubSubItem(id, val) {
    this.ms.getBoqSubSubItem(id, val).subscribe(res => {
      console.log(res);
      this.boqsubsublist[id] = res;
    });
  }
  getboqWorkPer(id, val) {
    this.ms.getBoqWorkPer(id, val).subscribe(res => {
      console.log(res);
      this.boqsWokperlist[id] = res;
      this.boqFutureForm.patchValue({
        CompletedPer: this.boqsWokperlist[id][0].CompletedPer
      });
    });
  }
  addMainItems() {
    this.boqtask.push({
      BOQId: 0,
      MainItemId: 0,
      MainItem: '',
      SubItem: '',
      SubSubItem: '',
      CompletedPer: 0,
      WorkdonePer: 0,
      WorkdoneType: ''
    });
  }
  deletemainItem(index) {
    this.boqItemArray.removeAt(index);
  }

  private getboqMainItem() {
    this.ms.getBoqMainItem().subscribe(res => {
      console.log(res);
      this.boqmainlist = res;
    });
  }
  private getboqpro(id) {
    this.ms.getBoqpro(id).subscribe(res => {
      console.log(res);
      this.boqtasklist = res;
    });
  }
  getboqItem(id) {
    this.ms.getBoqItemLite(id).subscribe(res => {
      console.log(res);
      this.boqprolist = res;
      this.boqprocessForm.patchValue({
        Date: this.boqprolist[0].Date,
        SubItem: this.boqprolist[0].SubItem,
        MainItem: this.boqprolist[0].MainItem,
        name: this.boqprolist[0].name,
        CompletedPer: this.boqprolist[0].CompletedPer
      });
    });
  }
  getboqData(id) {
    this.ms.getBoqData(id).subscribe(res => {
      console.log(res);
      this.boqdatalist = res;
    });
  }
  getvarData(id) {
    this.ms.getBoqpro(id).subscribe(res => {
      console.log(res);
      this.boqvarlist = res;
    });
  }
  createForm() {
    // this.boqprocessForm = this.fb.group({
    //   Date: this.today,
    //   BOQId: ['', Validators.required],
    //   SubItem: [''],
    //   MainItem: [''],
    //   name: [''],
    //   CompletedPer: [''],
    //   WorkdonePer: ['', Validators.required]
    // });

    this.boqFutureForm = this.fb.group({
      items: this.fb.array([this.addBoqFuture()])
    });

    // this.boqprocessForm.get('BOQId').valueChanges.subscribe(res => {
    //   this.getboqItem(res);
    // });
  }
  saveboqform() {
    console.log(this.boqFutureForm.get('items').value);
    this.ms
      .boqFProcessSubmit(this.boqFutureForm.get('items').value)
      .subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.getboqMainItem();
          this.createForm();
          this.getboqData(1);
        } else {
          this.alert.open({
            heading: 'Saving Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
  }
  get boqItemArray() {
    return this.boqFutureForm.get('items') as FormArray;
  }

  addBoqFuture() {
    return this.fb.group({
      MainItem: [null, Validators.required],
      SubItem: [null, Validators.required],
      BOQId: [null, Validators.required],
      CompletedPer: [0],
      WorkdonePer: [null, Validators.required]
    });
  }

  addNewBoqList() {
    this.boqItemArray.push(this.addBoqFuture());
  }

  // addsubItem() {
  //   this.modalTitle = 'Add BOQ Process';

  //   this.getboqpro(0);
  // }
  boqprocessSubmit() {
    console.log(this.boqtasklist);
    this.ms.boqProcessSubmit(this.boqtasklist).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.getboqpro(0);
      } else {
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
  boqvarSubmit() {
    console.log(this.boqvarlist);

    this.ms.boqProcessSubmit(this.boqvarlist).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });

        this.getvarData(2);
      } else {
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
  boqprocessShow() {
    this.modalTitle = 'Add BOQ Future Process';
    this.boqprocessForm.reset();
    this.modal.open(this.sampleText.id);
  }
  openModal() {
    this.modal.open(this.sampleText.id);
  }

  closeModal() {
    this.modal.close(this.sampleText.id);
  }
  boqwdSubmit() {
    console.log(this.boqprocessForm.value);
    this.ms.boqWDSubmit(this.boqprocessForm.value).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.closeModal();
        this.getboqpro(0);
      } else {
        this.alert.open({
          heading: 'Saving Failed',
          msg: res.message,
          type: 'danger',
          duration: 5000
        });
      }
    });
  }
}
