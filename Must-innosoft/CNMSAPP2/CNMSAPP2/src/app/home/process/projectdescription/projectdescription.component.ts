import { Component, OnInit } from '@angular/core';
import { MatTableDataSource } from '@angular/material';
import {
  ProjectDescriptionList,
  ExternalWorkMasterRes
} from './project-description';
import { ProcessService } from '../process.service';
import { ProjectMaster } from '../projectdetails/projectdetails';
import { NguAlertService } from '@ngu/alert';
import { forEach } from '@angular/router/src/utils/collection';
import { Router } from '@angular/router';
import { FormControl } from '@angular/forms';
import { Observable } from '../../../../../node_modules/rxjs';
import { map, startWith } from '../../../../../node_modules/rxjs/operators';

@Component({
  selector: 'app-projectdescription',
  templateUrl: './projectdescription.component.html',
  styleUrls: ['./projectdescription.component.scss']
})
export class ProjectdescriptionComponent implements OnInit {
  projectList: ProjectMaster[];
  externalmasterList: ExternalWorkMasterRes[];
  externalUOM: any[];
  projectDescList: ProjectDescriptionList;
  dataSource = new MatTableDataSource();
  filteredSuggestions: Observable<any[]>;
  formControl: FormControl;
  TCost: any;
  private fieldArray: Array<any> = [];
  private newAttribute: any = {};
  constructor(
    private ps: ProcessService,
    private alert: NguAlertService,
    private router: Router
  ) {
    this.formControl = new FormControl();
    this.filteredSuggestions = this.formControl.valueChanges.pipe(
      startWith(''),
      map(
        stringValue =>
          stringValue
            ? this.filterSuggestions(stringValue)
            : this.externalmasterList.slice()
      )
    );

    // let a = 'The Gap';
    // let b = a.toLowerCase().replace(/^(the )/, '');

    // console.log(b);
  }
  filterSuggestions(search: string) {
    return this.externalmasterList.filter(suggestion => {
      let found = false;
      suggestion.altTags
        .concat(suggestion.ExternalWork)
        .forEach(ExternalWork => {
          if (
            suggestion.ExternalWork.toLowerCase().indexOf(
              search.toLowerCase()
            ) === 0 ||
            suggestion.ExternalWork.toLowerCase()
              .replace(/^(the )|(le )/, '')
              .indexOf(search.toLowerCase()) === 0
          ) {
            found = true;
          }
        });
      return found;
    });
  }
  ngOnInit() {
    this.projectDescList = {
      ProjectId: '',
      ProjectDescription: {
        Foundation: { status: 1, qty: 0, FoundationDes: [] },
        Basement: { status: 1, qty: 0, FoundationDes: [] },
        Podium: { status: 1, qty: 0, FoundationDes: [] },
        Mezanine: { status: 1, qty: 0, FoundationDes: [] }
      },
      nameList: [
        {
          name: 'BLOCK',
          list: [
            {
              name: '',
              Floor: { status: 1, qty: 0, FoundationDes: [] },
              LowerRoof: { status: 1, qty: 0, FoundationDes: [] },
              UpperRoof: { status: 1, qty: 0, FoundationDes: [] }
            }
          ]
        }
      ],
      ExternalWorks: [
        {
          externalId: '',
          externalName: '',
          uom: '',
          qty: 0
        }
      ],
      MainItems: [
        {
          mainitem: '',
          cost: 0
        }
      ]
    };

    this.externalUOM = [
      {
        name: 'Nos',
        value: 'Nos'
      },
      {
        name: 'Kg',
        value: 'Kg'
      },
      {
        name: 'M',
        value: 'M'
      },
      {
        name: 'M2',
        value: 'M2'
      },
      {
        name: 'M3',
        value: 'M3'
      },
      {
        name: 'Sum',
        value: 'Sum'
      }
    ];

    this.getexternalmaser(0);
    this.getproject();
  }

  onChange($event, deviceValue) {
    console.log(deviceValue);
    this.getProjectDes(deviceValue);
  }
  onChangeqty($event, deviceValue) {
    this.projectDescList.ProjectDescription.Podium.FoundationDes.splice(
      0,
      this.projectDescList.ProjectDescription.Podium.FoundationDes.length
    );
    if (deviceValue !== '0') {
      const a =
        deviceValue -
        this.projectDescList.ProjectDescription.Podium.FoundationDes.length;
      for (let i = 0; i < a; i++) {
        this.projectDescList.ProjectDescription.Podium.FoundationDes.push({
          name: 'Podium-'
        });
      }
    }
  }
  onChangefun($event, deviceValue) {
    console.log(
      this.projectDescList.ProjectDescription.Foundation.FoundationDes.length
    );
    this.projectDescList.ProjectDescription.Foundation.FoundationDes.splice(
      0,
      this.projectDescList.ProjectDescription.Foundation.FoundationDes.length
    );
    if (deviceValue !== '0') {
      const a =
        deviceValue -
        this.projectDescList.ProjectDescription.Foundation.FoundationDes.length;
      for (let i = 0; i < a; i++) {
        this.projectDescList.ProjectDescription.Foundation.FoundationDes.push({
          name: 'Foundation-'
        });
      }
    }
  }
  onChangeBase($event, deviceValue) {
    console.log(
      this.projectDescList.ProjectDescription.Basement.FoundationDes.length
    );
    this.projectDescList.ProjectDescription.Basement.FoundationDes.splice(
      0,
      this.projectDescList.ProjectDescription.Basement.FoundationDes.length
    );
    if (deviceValue !== '0') {
      const a =
        deviceValue -
        this.projectDescList.ProjectDescription.Basement.FoundationDes.length;
      for (let i = 0; i < a; i++) {
        this.projectDescList.ProjectDescription.Basement.FoundationDes.push({
          name: 'Basement-'
        });
      }
    }
  }
  onChangeMaz($event, deviceValue) {
    console.log(
      this.projectDescList.ProjectDescription.Mezanine.FoundationDes.length
    );
    this.projectDescList.ProjectDescription.Mezanine.FoundationDes.splice(
      0,
      this.projectDescList.ProjectDescription.Mezanine.FoundationDes.length
    );
    if (deviceValue !== '0') {
      const a =
        deviceValue -
        this.projectDescList.ProjectDescription.Mezanine.FoundationDes.length;
      for (let i = 0; i < a; i++) {
        this.projectDescList.ProjectDescription.Mezanine.FoundationDes.push({
          name: 'Mezanine-'
        });
      }
    }
  }
  onChangeFlo($event, deviceValue) {
    console.log(this.projectDescList.nameList.length);
    if (deviceValue !== '0') {
      for (let i = 0; i < this.projectDescList.nameList.length; i++) {
        for (let j = 0; j < this.projectDescList.nameList[i].list.length; j++) {
          this.projectDescList.nameList[i].list[j].Floor.FoundationDes.splice(
            0,
            this.projectDescList.nameList[i].list[j].Floor.FoundationDes.length
          );

          if (deviceValue !== '0') {
            const a =
              deviceValue -
              this.projectDescList.nameList[i].list[j].Floor.FoundationDes
                .length;
            for (let k = 0; k < a; k++) {
              this.projectDescList.nameList[i].list[j].Floor.FoundationDes.push(
                {
                  name: 'Floor-'
                }
              );
            }
          }
        }
      }
    }
  }
  onChangeLFlo($event, deviceValue) {
    console.log(this.projectDescList.nameList.length);
    if (deviceValue !== '0') {
      for (let i = 0; i < this.projectDescList.nameList.length; i++) {
        for (let j = 0; j < this.projectDescList.nameList[i].list.length; j++) {
          this.projectDescList.nameList[i].list[
            j
          ].LowerRoof.FoundationDes.splice(
            0,
            this.projectDescList.nameList[i].list[j].LowerRoof.FoundationDes
              .length
          );
          if (deviceValue !== '0') {
            const a =
              deviceValue -
              this.projectDescList.nameList[i].list[j].LowerRoof.FoundationDes
                .length;
            for (let k = 0; k < a; k++) {
              this.projectDescList.nameList[i].list[
                j
              ].LowerRoof.FoundationDes.push({
                name: 'LOWER ROOF-'
              });
            }
          }
        }
      }
    }
  }
  onChangeUFlo($event, deviceValue) {
    console.log(this.projectDescList.nameList.length);
    if (deviceValue !== '0') {
      for (let i = 0; i < this.projectDescList.nameList.length; i++) {
        for (let j = 0; j < this.projectDescList.nameList[i].list.length; j++) {
          this.projectDescList.nameList[i].list[
            j
          ].UpperRoof.FoundationDes.splice(
            0,
            this.projectDescList.nameList[i].list[j].UpperRoof.FoundationDes
              .length
          );
          if (deviceValue !== '0') {
            const a =
              deviceValue -
              this.projectDescList.nameList[i].list[j].UpperRoof.FoundationDes
                .length;
            for (let k = 0; k < a; k++) {
              this.projectDescList.nameList[i].list[
                j
              ].UpperRoof.FoundationDes.push({
                name: 'UPPER ROOF-'
              });
            }
          }
        }
      }
    }
  }
  addFieldValue() {
    this.fieldArray.push(this.newAttribute);
    this.newAttribute = {};
  }

  deleteFieldValue(index) {
    this.fieldArray.splice(index, 1);
  }

  addExternal() {
    this.projectDescList.ExternalWorks.push({
      externalId: '',
      externalName: '',
      uom: '',
      qty: 0
    });
  }

  addList(index) {
    this.projectDescList.nameList[index].list.push({
      name: '',
      Floor: { status: 1, qty: 0, FoundationDes: [] },
      LowerRoof: { status: 1, qty: 0, FoundationDes: [] },
      UpperRoof: { status: 1, qty: 0, FoundationDes: [] }
    });
  }

  addNewBlock() {
    this.projectDescList.nameList.push({
      name: 'TOWER',
      list: [
        {
          name: '',
          Floor: { status: 1, qty: 0, FoundationDes: [] },
          LowerRoof: { status: 1, qty: 0, FoundationDes: [] },
          UpperRoof: { status: 1, qty: 0, FoundationDes: [] }
        }
      ]
    });
  }

  deleteItem(list) {
    this.projectDescList.ExternalWorks.splice(
      this.projectDescList.ExternalWorks.indexOf(list),
      1
    );
  }

  deleteList(index, list) {
    this.projectDescList.nameList[index].list.splice(
      this.projectDescList.nameList[index].list.indexOf(list),
      1
    );
  }

  getproject() {
    this.ps.getProject().subscribe(res => {
      this.projectList = res;
    });
  }

  getexternalmaser(id) {
    this.ps.getExternalMaser(id).subscribe(res => {
      this.externalmasterList = res;
    });
  }

  getProjectDes(id) {
    this.ps.getProjectDescription(id).subscribe(res => {
      console.log(res);
      // sthis.projectDescList = res[0];
    });
  }

  submit() {
    console.log(this.projectDescList);
    this.ps.addProjectDescription(this.projectDescList).subscribe(res => {
      console.log(res);
      if (res.status) {
        this.alert.open({
          heading: 'Saved Successfully',
          msg: res.message
        });
        this.clear();
        if (res.message === 'Saved Successfully') {
          this.router.navigate(['/home/process/boqdetails']);
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
  }

  addMainItems() {
    this.projectDescList.MainItems.push({
      mainitem: '',
      cost: 0
    });

    let sum = 0;
    for (let i = 0; i < this.projectDescList.MainItems.length; i++) {
      sum += this.projectDescList.MainItems[i]['cost'];
    }
    this.TCost = sum;
    console.log(this.TCost);
  }
  clear() {
    this.projectDescList = {
      ProjectId: '',
      ProjectDescription: {
        Foundation: { status: 1, qty: 0, FoundationDes: [{ name: '' }] },
        Basement: { status: 1, qty: 0, FoundationDes: [{ name: '' }] },
        Podium: { status: 1, qty: 0, FoundationDes: [{ name: '' }] },
        Mezanine: { status: 1, qty: 0, FoundationDes: [{ name: '' }] }
      },
      nameList: [
        {
          name: 'BLOCK',
          list: [
            {
              name: '',
              Floor: { status: 1, qty: 0, FoundationDes: [{ name: '' }] },
              LowerRoof: { status: 1, qty: 0, FoundationDes: [{ name: '' }] },
              UpperRoof: { status: 1, qty: 0, FoundationDes: [{ name: '' }] }
            }
          ]
        }
      ],
      ExternalWorks: [
        {
          externalId: '',
          externalName: '',
          uom: '',
          qty: 0
        }
      ],
      MainItems: [
        {
          mainitem: '',
          cost: 0
        }
      ]
    };

    this.externalUOM = [
      {
        name: 'Nos',
        value: 'Nos'
      },
      {
        name: 'Kg',
        value: 'Kg'
      },
      {
        name: 'M',
        value: 'M'
      },
      {
        name: 'M2',
        value: 'M2'
      },
      {
        name: 'M3',
        value: 'M3'
      },
      {
        name: 'Sum',
        value: 'Sum'
      }
    ];

    this.getexternalmaser(0);
    this.getproject();
  }
  deletemainItem(list) {
    this.projectDescList.MainItems.splice(
      this.projectDescList.MainItems.indexOf(list),
      1
    );
  }
}
