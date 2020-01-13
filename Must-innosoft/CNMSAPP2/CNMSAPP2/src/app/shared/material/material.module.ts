import { NgModule, Injectable } from '@angular/core';
import {
  MatSelectModule,
  MatInputModule,
  MatRadioModule,
  MatDatepickerModule,
  MatProgressSpinnerModule,
  MatNativeDateModule,
  MatButtonModule,
  MAT_DATE_LOCALE,
  MAT_DATE_FORMATS,
  NativeDateAdapter,
  DateAdapter,
  MatTableModule,
  MatToolbarModule,
  MatSidenavModule,
  MatIconModule,
  MatExpansionModule,
  MatListModule,
  MatCardModule,
  MatPaginatorModule
} from '@angular/material';

const MY_DATE_FORMATS = {
  parse: {
    dateInput: { day: 'numeric', month: 'short', year: 'numeric' },
    dateOutput: { day: 'numeric', month: 'short', year: 'numeric' }
  },
  display: {
    // dateInput: { month: 'short', year: 'numeric', day: 'numeric' },
    dateInput: 'input',
    monthYearLabel: { month: 'short', year: 'numeric' },
    dateA11yLabel: { day: 'numeric', month: 'long', year: 'numeric' },
    monthYearA11yLabel: { month: 'long', year: 'numeric' }
  }
};

// @Injectable()
// export class MyDateAdapter extends NativeDateAdapter {
//   format(date: Date, displayFormat: Object): string {
//     if (displayFormat === 'input') {
//       const day = date.getDate();
//       const month = date.getMonth() + 1;
//       const year = date.getFullYear();
//       return this._to2digit(day) + '/' + this._to2digit(month) + '/' + year;
//     } else {
//       return date.toDateString();
//     }
//   }

//   private _to2digit(n: number) {
//     return ('00' + n).slice(-2);
//   }
// }

@Injectable()
export class AppDateAdapter extends NativeDateAdapter {
  parse(value: any): Date | null {
    if (typeof value === 'string' && value.indexOf('/') > -1) {
      const str = value.split('/');
      const year = Number(str[2]);
      const month = Number(str[1]) - 1;
      const date = Number(str[0]);
      return new Date(year, month, date);
    }
    const timestamp = typeof value === 'number' ? value : Date.parse(value);
    return isNaN(timestamp) ? null : new Date(timestamp);
  }
  format(date: Date, displayFormat: Object): string {
    if (displayFormat === 'input') {
      const day = date.getDate();
      const month = date.getMonth() + 1;
      const year = date.getFullYear();
      return this._to2digit(day) + '/' + this._to2digit(month) + '/' + year;
    } else {
      return date.toDateString();
    }
  }

  private _to2digit(n: number) {
    return ('00' + n).slice(-2);
  }
}

@NgModule({
  imports: [],
  exports: [
    MatSelectModule,
    MatInputModule,
    MatRadioModule,
    MatDatepickerModule,
    MatProgressSpinnerModule,
    MatNativeDateModule,
    MatButtonModule,
    MatTableModule,
    MatToolbarModule,
    MatSidenavModule,
    MatIconModule,
    MatExpansionModule,
    MatListModule,
    MatCardModule,
    MatPaginatorModule
  ],
  declarations: [],
  providers: [
    { provide: MAT_DATE_LOCALE, useValue: 'IN' },
    { provide: MAT_DATE_FORMATS, useValue: MY_DATE_FORMATS },
    { provide: DateAdapter, useClass: AppDateAdapter }
  ]
})
export class MaterialModule {}
