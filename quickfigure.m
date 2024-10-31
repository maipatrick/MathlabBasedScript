close all

figure(2)

subplot(4,3,1)
plot(NORMAL.R.GRF.DATA.X, 'k')
ylabel ('GRF X')
box off
stan_plot_stance

subplot(4,3,2)
plot(NORMAL.R.GRF.DATA.Y, 'k')
ylabel ('GRF Y')
box off
stan_plot_stance

subplot(4,3,3)
plot(NORMAL.R.GRF.DATA.Z, 'k')
ylabel ('GRF Z')
box off
stan_plot_stance

subplot(4,3,4)
plot(NORMAL.R.MOMENTS.RIGHT_HIP.X, 'k')
ylabel ('Hip ab/add [Nm/kg]')
box off
stan_plot_stance


subplot(4,3,5)
plot(NORMAL.R.MOMENTS.RIGHT_HIP.Y, 'k')
ylabel ('Hip flex [Nm/kg]')
box off
stan_plot_stance

subplot(4,3,6)
plot(NORMAL.R.MOMENTS.RIGHT_HIP.Z, 'k')
ylabel ('Hip rot [Nm/kg]')
box off
stan_plot_stance


subplot(4,3,7)
plot(NORMAL.R.MOMENTS.RIGHT_KNEE.X, 'k')
ylabel ('Knee ab/add [Nm/kg]')
box off
stan_plot_stance


subplot(4,3,8)
plot(NORMAL.R.MOMENTS.RIGHT_KNEE.Y, 'k')
ylabel ('Knee flex [Nm/kg]')
box off
stan_plot_stance

subplot(4,3,9)
plot(NORMAL.R.MOMENTS.RIGHT_KNEE.Z, 'k')
ylabel ('Knee rot [Nm/kg]')
box off
stan_plot_stance


subplot(4,3,10)
plot(NORMAL.R.MOMENTS.RIGHT_ANKLE.X, 'k')
ylabel ('Ankle in/ev [Nm/kg]')
box off
stan_plot_stance


subplot(4,3,11)
plot(NORMAL.R.MOMENTS.RIGHT_ANKLE.Y, 'k')
ylabel ('Ankle dorsiflex [Nm/kg]')
box off
stan_plot_stance

subplot(4,3,12)
plot(NORMAL.R.MOMENTS.RIGHT_ANKLE.Z, 'k')
ylabel ('Ankle rot [Nm/kg]')
box off
stan_plot_stance