import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { LocationMaster } from './locationdetails';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';

@Component({
  selector: 'app-locationdetails',
  templateUrl: './locationdetails.component.html',
  styleUrls: ['./locationdetails.component.scss']
})
export class LocationdetailsComponent implements OnInit {
  locationList: LocationMaster[];
  modalTitle: string;
  isAdd: boolean;
  locationForm: FormGroup;
  sampleText: NguModal;

  displayedColumns = ['LocationName', 'Action'];
  dataSource = new MatTableDataSource(this.locationList);
  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService
  ) {}

  ngOnInit() {
    this.getlocation();

    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }

  private getlocation() {
    this.ms.getLocation().subscribe(res => {
      console.log(res);
      this.locationList = res;
      this.dataSource.data = this.locationList;
    });
  }

  createForm() {
    this.locationForm = this.fb.group({
      LocationId: '',
      LocationName: ['', Validators.required],
      Status: ['', Validators.required]
    });
  }

  locationSubmit() {
    console.log(this.locationForm.value);
    if (this.isAdd) {
      this.ms.addLocation(this.locationForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Saved Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getlocation();
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
      this.ms.updateLocation(this.locationForm.value).subscribe(res => {
        console.log(res);
        if (res.status) {
          this.alert.open({
            heading: 'Updated Successfully',
            msg: res.message
          });
          this.closeModal();
          this.getlocation();
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

  editlocation(row) {
    this.modalTitle = 'Edit Location';
    this.isAdd = false;
    console.log(row);

    this.locationForm.patchValue({
      LocationId: row.LocationId,
      LocationName: row.LocationName,
      Status: row.Status
    });
    this.modal.open(this.sampleText.id);
    // this.companyForm.reset();
  }

  addlocation() {
    this.modalTitle = 'Add Location';
    this.isAdd = true;
    this.getlocation();
    this.locationForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
