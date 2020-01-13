import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqreportsComponent } from './boqreports.component';

describe('BoqreportsComponent', () => {
  let component: BoqreportsComponent;
  let fixture: ComponentFixture<BoqreportsComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqreportsComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqreportsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
