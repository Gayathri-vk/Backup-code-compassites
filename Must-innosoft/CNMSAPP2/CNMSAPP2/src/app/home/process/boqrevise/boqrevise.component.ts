import { Component, OnInit } from '@angular/core';
import { ProcessService } from '../process.service';
import { BOQREV } from './boqrevise';
import { NguAlertService } from '@ngu/alert';
import { NguModalService, NguModal } from '@ngu/modal';
import { MatTableDataSource } from '@angular/material';
@Component({
  selector: 'app-boqrevise',
  templateUrl: './boqrevise.component.html',
  styleUrls: ['./boqrevise.component.scss']
})
export class BoqreviseComponent implements OnInit {
  boqrevlist: BOQREV[];
  boqvarrevlist: BOQREV[];
  boqrevcoplist: BOQREV[];
  sampleText: NguModal;
  chk: any;
  constructor(
    private ms: ProcessService,
    private alert: NguAlertService,
    private modal: NguModalService
  ) {}

  ngOnInit() {
    this.getreviseItem(0);
    this.getvarreItem(1);
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '80%', md: '1200px', lg: '1400px' }
    };
  }
  getreviseItem(id) {
    this.ms.getReviseItem(id).subscribe(res => {
      console.log(res);
      this.boqrevlist = res;
    });
  }
  getvarreItem(id) {
    this.ms.getReviseItem(id).subscribe(res => {
      console.log(res);
      this.boqvarrevlist = res;
    });
  }
  getrevcop(id) {
    this.ms.getReviseItem(id).subscribe(res => {
      console.log(res);
      this.boqrevcoplist = res;
    });
  }
  boqreviseSubmit() {
    console.log(this.boqrevlist);
    this.ms.boqReviseSubmit(this.boqrevlist).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.getreviseItem(0);
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

  Freeze() {
    this.modal.open(this.sampleText.id);
    this.getrevcop(3);
    this.chk = 1;
  }
  Freezesave() {
    if (this.chk === 1) {
      this.boqrevlist[0].ftype = 'F';
      console.log(this.boqrevlist);
      this.ms.boqReviseSubmit(this.boqrevlist).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getreviseItem(0);
        } else {
          this.alert.open({
            heading: 'Saving Failed',
            msg: res.message,
            type: 'danger',
            duration: 5000
          });
        }
      });
    } else if (this.chk === 2) {
      this.boqvarrevlist[0].ftype = 'F';
      console.log(this.boqvarrevlist);
      this.ms.boqReviseSubmit(this.boqvarrevlist).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getvarreItem(1);
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

  closeModal() {
    this.modal.close(this.sampleText.id);
    this.chk = 0;
  }
  boqVareviseSubmit() {
    console.log(this.boqvarrevlist);
    this.ms.boqReviseSubmit(this.boqvarrevlist).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });

        this.getvarreItem(1);
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
  FreezeVar() {
    this.modal.open(this.sampleText.id);
    this.getrevcop(4);
    this.chk = 2;
  }
  // FreezeVarSave() {
  //   this.boqvarrevlist[0].ftype = 'F';
  //   console.log(this.boqvarrevlist);
  //   this.ms.boqReviseSubmit(this.boqvarrevlist).subscribe(res => {
  //     console.log(res);
  //     if (res.status) {
  //       this.alert.open({
  //         heading: 'Saved Successfully',
  //         msg: res.message
  //       });
  //       this.closeModal();
  //       this.getvarreItem(1);
  //     } else {
  //       this.alert.open({
  //         heading: 'Saving Failed',
  //         msg: res.message,
  //         type: 'danger',
  //         duration: 5000
  //       });
  //     }
  //   });
  // }
}
