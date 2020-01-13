import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ImportBoqComponent } from './import-boq.component';

describe('ImportBoqComponent', () => {
  let component: ImportBoqComponent;
  let fixture: ComponentFixture<ImportBoqComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ImportBoqComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ImportBoqComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
