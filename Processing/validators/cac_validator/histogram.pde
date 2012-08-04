

// custom chart display for histograms
class ChartHistogramDisplay implements ControllerDisplay {

  Chart chart;

  public ChartHistogramDisplay(Chart theChart) {
    chart = theChart;
  }

  public void display(PApplet theApplet, Controller theController) {
    int width = chart.getWidth();
    int height = chart.getHeight();              
    pushStyle();
    fill(color(chart.getColor().getBackground(), chart.size() > 1 ? 255 : 32));
    rect(0, 0, width, height);
    for (int n = 0; n < chart.size(); n++) {
      ChartDataSet dataset = chart.getDataSet(n);
      float resolution =  (float) width / dataset.size();
      noStroke();
      // rescale values
      float vmax = 0;
      for (int i = 0; i < dataset.size(); i++) {  
        vmax = PApplet.max(vmax, dataset.get(i).getValue());
      }
      float vscale = height / vmax;
      for (int i = 0; i < dataset.size(); i++) {
        ChartData data = dataset.get(i);
        fill(data.getColor());
        rect(i * resolution, height, resolution, -data.getValue() * vscale);
      }
    }
    noStroke();
    popStyle();
  }

}


ArrayList<Float> getEdgeLengths() {
  Iterator<HE_Edge> eItr = working_mesh.eItr();
  ArrayList<Float> dataset = new ArrayList();
  while(eItr.hasNext()) {
    HE_Edge edge = eItr.next();
    float l = (float) edge.getLength();
    dataset.add(l);
  }
  return dataset;
}


