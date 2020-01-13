import { NgModule, CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';
import { CommonModule } from '@angular/common';
import { MasterRoutedComponents, MasterRoutingModule } from './master.routing';
import { SharedModule } from '../../shared/shared.module';
import { MasterService } from './master.service';
import { MatTableModule } from '../../../../node_modules/@angular/material';

@NgModule({
  imports: [CommonModule, MasterRoutingModule, SharedModule, MatTableModule],
  declarations: [MasterRoutedComponents],
  providers: [MasterService],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
  bootstrap: [MasterRoutedComponents]
})
export class MasterModule {}
