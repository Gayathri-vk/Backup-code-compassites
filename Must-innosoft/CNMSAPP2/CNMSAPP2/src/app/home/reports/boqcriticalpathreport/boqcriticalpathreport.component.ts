import { Component, OnInit, ViewChild } from '@angular/core';
import { BOQCriticalPath } from './boqcriticalpathreport';
import { MatPaginator, MatTableDataSource } from '@angular/material';
import { ReportsService } from '../reports.service';
import { Angular2Csv } from 'angular2-csv';

@Component({
  selector: 'app-boqcriticalpathreport',
  templateUrl: './boqcriticalpathreport.component.html',
  styleUrls: ['./boqcriticalpathreport.component.scss']
})
export class BoqcriticalpathreportComponent implements OnInit {
  BoqCpathlist: BOQCriticalPath[];
  @ViewChild(MatPaginator) paginator: MatPaginator;
  displayedColumns = ['text', 'name', 'subitem', 'subsubitem', 'duration'];
  dataSource = new MatTableDataSource(this.BoqCpathlist);
  constructor(private ms: ReportsService) {}

  ngOnInit() {
    this.getbOQCPath(5);
    this.dataSource.paginator = this.paginator;
  }
  getbOQCPath(id) {
    this.ms.getBOQCPath(id).subscribe(res => {
      console.log(res);
      this.BoqCpathlist = res;
      this.dataSource.data = this.BoqCpathlist;
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
    new Angular2Csv(this.BoqCpathlist, 'BOQ Critical Path Report', options);
  }
  applyFilter(filterValue: string) {
    filterValue = filterValue.trim(); // Remove whitespace
    filterValue = filterValue.toLowerCase(); // MatTableDataSource defaults to lowercase matches
    this.dataSource.filter = filterValue;
  }
}
