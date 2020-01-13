import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQReviceDetail } from './boqreviseview';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { ProcessService } from '../process.service';
import { Angular2Csv } from 'angular2-csv';

@Component({
  selector: 'app-boqreviseview',
  templateUrl: './boqreviseview.component.html',
  styleUrls: ['./boqreviseview.component.scss']
})
export class BoqreviseviewComponent implements OnInit {
  BoqreviceList: BOQReviceDetail[];
  @ViewChild(MatPaginator) paginator: MatPaginator;
  displayedColumns = [
    'ReviseType',
    'RStartDate',
    'REndDate',
    'name',
    'mainItem',
    'subitem',
    'subsubitem',
    'boq',
    'task',
    'start_date',
    'end_date'
  ];
  dataSource = new MatTableDataSource(this.BoqreviceList);
  constructor(private ms: ProcessService) {}

  ngOnInit() {
    this.getbOQRevice(2);
    this.dataSource.paginator = this.paginator;
  }
  getbOQRevice(id) {
    this.ms.getBOQRevice(id).subscribe(res => {
      console.log(res);
      this.BoqreviceList = res;
      this.dataSource.data = this.BoqreviceList;
    });
  }
  exportData() {
    const options = {
      // fieldSeparator: ',',
      // quoteStrings: '"',
      decimalseparator: '.',
      showLabels: true,
      showTitle: true,
      useBom: true
    };
    // tslint:disable-next-line:no-unused-expression
    new Angular2Csv(this.BoqreviceList, 'BOQ Revise View', options);
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
