import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import { ProjectMaster, ClientProjectRes } from './projectdetails';
import { NguModal, NguModalService } from '@ngu/modal';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { NguAlertService } from '@ngu/alert';
import { ProcessService } from '../process.service';
import { AuthService } from '../../../shared/core';

@Component({
  selector: 'app-projectdetails',
  templateUrl: './projectdetails.component.html',
  styleUrls: ['./projectdetails.component.scss']
})
export class ProjectdetailsComponent implements OnInit {
  projectList: ProjectMaster[];
  clientList: ClientProjectRes;
  modalTitle: string;
  isAdd: boolean;
  projectForm: FormGroup;
  sampleText: NguModal;
  userRole: number;
  projectList1: ProjectMaster[];
  displayedColumns = [
    'ClientName',
    'ProjectName',
    'ProjectLocation',
    // 'ProjectIncharge',
    'Start_Date',
    'End_Date',
    'ProjectDuration',
    'Action'
  ];
  dataSource = new MatTableDataSource(this.projectList);

  constructor(
    private ms: ProcessService,
    private modal: NguModalService,
    private fb: FormBuilder,
    private alert: NguAlertService,
    private auth: AuthService
  ) {}

  ngOnInit() {
    this.getproject();
    this.userRole = this.auth.userRole;
    this.sampleText = {
      id: 'sampleTextID',
      backdrop: false,
      width: { xs: '100%', sm: '70%', md: '500px', lg: '500px' }
    };

    this.createForm();
  }
  private getproject() {
    this.ms.getProject().subscribe(res => {
      console.log(res);
      this.projectList = res;
      this.dataSource.data = this.projectList;
    });
  }

  getClient(id) {
    this.ms.getClient(id).subscribe(res => {
      console.log(res);
      this.clientList = res;
    });
  }
  createForm() {
    this.projectForm = this.fb.group({
      ProjectId: '',
      ClientId: ['', Validators.required],
      ProjectName: ['', Validators.required],
      ProjectLocation: '',
      // ProjectIncharge: '',
      // ContactNo: '',
      // EmailId: '',
      Start_Date: ['', Validators.required],
      End_Date: ['', Validators.required],
      Status: ['', Validators.required],
      Fromday: ['', Validators.required],
      Today: ['', Validators.required],
      Fromtime: ['', Validators.required],
      Totime: ['', Validators.required]
    });
  }

  projectSubmit() {
    console.log(this.projectForm.value);

    if (this.projectForm.value.Fromday !== this.projectForm.value.Today) {
      if (this.isAdd) {
        this.ms.addProject(this.projectForm.value).subscribe(res => {
          console.log(res);
          if (res.status) {
            this.alert.open({
              heading: 'Saved Successfully',
              msg: res.message
            });
            this.closeModal();
            this.getproject();
            if (res.message === 'Saved Successfully') {
              window.location.reload();
            }
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
        this.ms.updateProject(this.projectForm.value).subscribe(res => {
          console.log(res);
          if (res.status) {
            this.alert.open({
              heading: 'Updated Successfully',
              msg: res.message
            });
            this.closeModal();
            this.getproject();
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
    } else {
      this.alert.open({
        heading: 'Update Failed',
        msg: 'Check From Day & To Day',
        type: 'danger',
        duration: 5000
      });
    }
  }

  openModal() {
    this.modal.open(this.sampleText.id);
  }

  closeModal() {
    this.modal.close(this.sampleText.id);
  }
  editproject(row) {
    this.modalTitle = 'Edit Project';
    this.isAdd = false;
    console.log(row);
    this.getClient(1);

    // this.ms.getProjectDet(0).subscribe(res => {
    //   console.log(res);
    //   this.projectList1 = res;
    // });
    this.projectForm.patchValue({
      ProjectId: row.ProjectId,
      ClientId: row.ClientId,
      ProjectName: row.ProjectName,
      ProjectLocation: row.ProjectLocation,
      // ProjectIncharge: row.ProjectIncharge,
      // ContactNo: row.ContactNo,
      // EmailId: row.EmailId,
      Start_Date: row.Start_Date,
      End_Date: row.End_Date,
      Status: row.Status,
      Fromday: row.Fromday,
      Today: row.Today,
      Fromtime: row.Fromtime,
      Totime: row.Totime
    });
    this.modal.open(this.sampleText.id);
    // this.companyForm.reset();
  }

  addproject() {
    this.modalTitle = 'Add Project';
    this.isAdd = true;
    this.getproject();
    this.getClient(1);
    this.projectForm.reset();
    this.modal.open(this.sampleText.id);
  }

  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
