import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqprocessComponent } from './boqprocess.component';

describe('BoqprocessComponent', () => {
  let component: BoqprocessComponent;
  let fixture: ComponentFixture<BoqprocessComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqprocessComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqprocessComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
