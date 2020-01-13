import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqTableComponent } from './boq-table.component';

describe('BoqTableComponent', () => {
  let component: BoqTableComponent;
  let fixture: ComponentFixture<BoqTableComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqTableComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
