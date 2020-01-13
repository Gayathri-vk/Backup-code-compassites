import { NgModule } from '@angular/core';
import { SharedModule } from '../../shared/shared.module';
import {
  ProcessRoutingModule,
  ProcessRoutedComponents
} from './process.routing';
import { ProcessService } from './process.service';
import { NguTreedModule } from '@ngu/tree';
import { BoqTableComponent } from './boqdetails/boq-table/boq-table.component';
import { MatAutocompleteModule } from '../../../../node_modules/@angular/material';

@NgModule({
  imports: [
    ProcessRoutingModule,
    SharedModule,
    NguTreedModule,
    MatAutocompleteModule
  ],
  declarations: [ProcessRoutedComponents, BoqTableComponent],
  providers: [ProcessService],
  bootstrap: [BoqTableComponent]
})
export class ProcessModule {}
